sub init()
    m.top.functionName = "getContent"
end sub

sub getContent()
    feedurl = m.global.feedurl

    ' Configura o MessagePort e o UrlTransfer
    m.port = CreateObject("roMessagePort")
    searchRequest = CreateObject("roUrlTransfer")
    searchRequest.setURL(feedurl)
    searchRequest.EnableEncodings(true)

    ' Configura o certificado se a URL for HTTPS
    httpsReg = CreateObject("roRegex", "^https:", "")
    if httpsReg.isMatch(feedurl)
        searchRequest.SetCertificatesFile("common:/certs/ca-bundle.crt")
        searchRequest.AddHeader("X-Roku-Reserved-Dev-Id", "")
        searchRequest.InitClientCertificates()
    end if

    ' Faz a requisição e obtém a resposta
    response = searchRequest.getToString()
    if response = invalid
        print "Failed to get response from URL"
        return
    end if

    ' Analisa a resposta JSON
    jsonParser = ParseJson(response)
    if jsonParser = invalid
        print "Failed to parse JSON response"
        return
    end if

    ' Cria um ContentNode para a estrutura
    con = CreateObject("roSGNode", "ContentNode")

    ' Popula o ContentNode com os dados do JSON
    for each item in jsonParser
        node = CreateObject("roSGNode", "ContentNode")
        
        ' Ajuste os campos conforme necessário
        node.title = item.title
        node.poster = item.image_url
        node.url = item.url
        
        ' Adiciona o node ao ContentNode principal
        con.appendChild(node)
    end for

    ' Define o conteúdo do top node
    m.top.content = con
end sub
