package main

import (
	"fmt"
	"net/http"
	"io/ioutil"
	"net/url"
	"strings"
	"crypto/tls"
	"encoding/json"
	"log"
)

var (
	token string
	code string
	// ch chan<- struct{} 
)
var ch = make(chan int, 10)


//struct里各个字段的大小写问题，encoding/json默认只认首字母大写的字段。
//否则无法识别
type TokenInfo struct {
	Result int
	Errmsg string
	Access_token string
}

type User struct {
	Userid string
	Name string
}

type PersonInfo struct {
	Result int
	Errmsg string
	User User	
}

func (personInfo *PersonInfo) showPersonInfo() {
	log.Println("show personInfo :")
    fmt.Println("\tresult\t:", personInfo.Result)
    fmt.Println("\terrmsg\t:", personInfo.Errmsg)
    fmt.Println("\tuserid\t:", personInfo.User.Userid)
    fmt.Println("\tuserName\t:", personInfo.User.Name)
}

func (token *TokenInfo) showTokenInfo() {
     log.Println("show tokenInfo :")
     fmt.Println("\tresult\t:", token.Result)
     fmt.Println("\terrmsg\t:", token.Errmsg)
     fmt.Println("\taccess_token\t:", token.Access_token)
 }


func httpGet(url string) []byte {
	tr := &http.Transport{
         TLSClientConfig:    &tls.Config{InsecureSkipVerify: true},
    }
    client := &http.Client{Transport: tr}
    resp, err := client.Get(url)

	// resp, err := http.Get(url)

	if err != nil {
		// handle error
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		// handle error
	}

	log.Println("response from 口袋助理 server : ", string(body))

	return body
}

//第三方server向口袋助理server请求token
func getAccess_token() {
	fmt.Println("==========================================================")
	log.Println("start to request to 口袋助理 server for access_token........")

	url := "https://200.200.107.235:4430/cgi-bin/oauth/access_token?appid=65541&did=10000&secret=12345"
	body := httpGet(url)

	tokenInfo := &TokenInfo{}
	err := json.Unmarshal([]byte(body), &tokenInfo)//解析json到struct{}
	if err != nil {
		log.Println("解析json串出错！！！", err)
		return
	}
	log.Println("解析json为：")
	tokenInfo.showTokenInfo()

	token = tokenInfo.Access_token

}

//第三方server向口袋助理server请求用户信息（通过token，code）
func getPersonInfo(token, code string) User {

	log.Println("第三方server传递给口袋助理的code：", code)

	url :=  fmt.Sprintf("https://200.200.107.235:4430/cgi-bin/roster/user/get?access_token=%s&code=%s&detail=0", token, code)
	body := httpGet(url)

	personInfo := &PersonInfo{}
	err := json.Unmarshal([]byte(body), &personInfo)
	if err != nil {
		log.Println("解析json串出错！！！", err)
		// return struct{}
	}
	log.Println("解析json为：")
	personInfo.showPersonInfo()

	user := personInfo.User

	return user
}

//第三方APP将口袋助理返回的code传给第三方server
func thirdApp2thirdServer(rw http.ResponseWriter, req *http.Request)  {

	fmt.Println("==========================================================")
	log.Println("thirdApp start to request......")
	// analyze(string(*req))

    queryForm, err := url.ParseQuery(req.URL.RawQuery)
    if err == nil && len(queryForm["code"]) > 0 {
    	log.Println("第三方APP传过来的code：", string(queryForm["code"][0]))

    	code = queryForm["code"][0]
    	ch <- 0
    	// getPersonInfo(token, code)
    }

    // close(ch)
}

//第三方APP向第三方server请求用户信息
func app2serverForPersonInfo(rw http.ResponseWriter, req *http.Request) {

	fmt.Println("==========================================================")
	log.Println("start to request to 口袋助理 server for person info........")

/**
	由于go的每个http请求是异步线程的
	为了保证每次请求用户信息前能够得到code
	这里使用了管道来做同步：
		原理是：管道上的发送操作发生在管道的接收完成之前
*/
	<-ch
	user := getPersonInfo(token, code)
	userStr, err := json.Marshal(user)//转换struct{}到json串
	if err!= nil {
		return
	}
	log.Println("user: ", string(userStr))

	fmt.Fprintln(rw, string(userStr))
}

func main() {
	//每次调用获取access_token的接口都会更新access_token，上次的access_token将会被新的覆盖失效
	//所有向口袋助理请求的接口都需要带上token
	getAccess_token()

    http.HandleFunc("/thirdApp2thirdServer", thirdApp2thirdServer)
    http.HandleFunc("/app2serverForPersonInfo", app2serverForPersonInfo)

    log.Println("server listen to the port 8001")
    err := http.ListenAndServe(":8001", nil)
    if err != nil {
    	log.Println("create server is failed!!!")
    	log.Println("error is : ", err)
    	return
    }

 	// httpGet()

}

func analyze(s string) {
	// 解析URL，并保证没有错误
	u, err := url.Parse(s)
	if err != nil {
		panic(err)
	}

	// 可以直接访问解析后的模式
	// fmt.Println(u.Scheme)

	// User包含了所有的验证信息，使用
	// Username和Password来获取单独的信息
	// fmt.Println(u.User)
	// fmt.Println(u.User.Username())
	// p, _ := u.User.Password()
	// fmt.Println(p)

	// Host包含了主机名和端口，如果需要可以
	// 手动分解主机名和端口
	fmt.Println(u.Host)
	h := strings.Split(u.Host, ":")
	fmt.Println(h[0])
	fmt.Println(h[1])

	// 这里我们解析出路径和`#`后面的片段
	fmt.Println(u.Path)
	fmt.Println(u.Fragment)

	// 为了得到`k=v`格式的查询参数，使用RawQuery。你可以将
	// 查询参数解析到一个map里面。这个map为字符串作为key，
	// 字符串切片作为value。
	// fmt.Println(u.RawQuery)
	// m, _ := url.ParseQuery(u.RawQuery)
	// fmt.Println(m)
	// fmt.Println(m["k"][0])

}
