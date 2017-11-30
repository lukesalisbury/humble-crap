import QtQuick 2.0
import QtWebEngine 1.5

Rectangle {
    id: pageCaptcha
    color: "#60000000"
    opacity: 1
    z: 1
    x: 0
    y: 0
    width: 320
    height: 200
    anchors.fill: parent

    Rectangle {
        id: rectangle
        width: 200
        height: 20
        color: "#d12020"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: text1
            x: 0
            y: 0
            text: qsTr("Please complete this captcha")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
        }
    }
    WebEngineView {

        id: captchaView
        audioMuted: true

        anchors.top: parent.top
        anchors.topMargin: 20
        clip: true
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        url: "https://www.humblebundle.com/user/captcha"

        onLoadingChanged: function (loadRequest) {
            if (loadRequest.status == WebEngineView.LoadSucceededStatus) {
                runJavaScript(
                            "
$('input[type=submit]').click(function(e){
      e.preventDefault();
      var challenge = '';
      var response = captcha.get_response();
      console.warn('humblecrap ' + response);
      })


")
            }
        }
        onJavaScriptConsoleMessage: function (level, message) {

            if (message.startsWith('humblecrap')) {
                var cap = message.split(' ')

                if (cap.length == 2 )
                {
                    humbleUser.setCaptcha('', cap[1])
                    humbleUser.login(inputUser.text, inputPassword.text,
                                     inputPin.text)

                    pageCaptcha.destroy()
                   }
            }
        }
    }
}
