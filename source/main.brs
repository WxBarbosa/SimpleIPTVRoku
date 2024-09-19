sub Main()
    reg = CreateObject("roRegistrySection", "profile")
    if reg.Exists("apiurl") then
        url = reg.Read("apiurl")
    else
        url = "http://192.168.1.218:5000/media?page=1&per_page=12&playlist_id=1" ' Alterar para o URL da sua API
    end if

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    m.global = screen.getGlobalNode()
    m.global.addFields({feedurl: url})
    scene = screen.CreateScene("MainScene")
    screen.show()

    while(true) 
        msg = wait(0, m.port)
        msgType = type(msg)
        print "msgTYPE >>>>>>>>"; type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub
