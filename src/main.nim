import std/[strutils, times]
import nigui
import jwtDecode

app.init()

let Win=newWindow("JWT Decode")
Win.width=1200
Win.height=800

let con=newLayoutContainer(Layout_Vertical)  ## メイン(一番外側)
Win.add(con)

# ==================================================
# JWT token
# ==================================================
let
  jwtCon=newLayoutContainer(Layout_Horizontal)  ## JWTデコード部分
  jwtBfCon=newLayoutContainer(Layout_Vertical)  ## JWTデコード前部分 
  jwtAfCon=newLayoutContainer(Layout_Vertical)  ## JWTデコード後部分 
  tokenLa=newLabel("JWT Token")
  tokenTa=newTextArea()  ## JWTトークン
  headerLa=newLabel("Header")
  headerTa=newTextArea()  ## デコード後ヘッダ
  payloadLa=newLabel("Payload")
  payloadTa=newTextArea()  ## デコード後ペイロード 
  signatureLa=newLabel("Signature")
  signatureTa=newTextArea()  ## デコード後署名

jwtCon.add(jwtBfCon)
jwtCon.add(jwtAfCon)

# ----------------------------------------
# 変換前
# ----------------------------------------
jwtBfCon.add(tokenLa)
tokenTa.onTextChange=proc(event: TextChangeEvent) =
  try:
    (headerTa.text, payloadTa.text, signatureTa.text) = jwtDec(tokenTa.text)
    headerTa.text = headerTa.text.replaceWord("\n", "\r\n")
    payloadTa.text = payloadTa.text.replaceWord("\n", "\r\n")
    signatureTa.text = payloadTa.text.pickTs()
  except:
    headerTa.text = ""
    payloadTa.text = ""
    signatureTa.text = ""
jwtBfCon.add(tokenTa)

# ----------------------------------------
# 変換後
# ----------------------------------------
jwtAfCon.add(headerLa)
headerTa.editable=false
headerTa.height=120
jwtAfCon.add(headerTa)

jwtAfCon.add(payloadLa)
payloadTa.editable=false
jwtAfCon.add(payloadTa)

jwtAfCon.add(signatureLa)
signatureTa.editable=false
signatureTa.height=120
jwtAfCon.add(signatureTa)

con.add(jwtCon)

# ==================================================
# Timestamp
# ==================================================
let
  tsLa=newLabel("Timestamp変換")
  tsCon=newLayoutContainer(Layout_Horizontal)  ## Timestamp部分
  tsTx=newTextBox()
  tsAfTx=newTextBox()

tsTx.onTextChange=proc(event: TextChangeEvent) =
  try:
    tsAfTx.text = $fromUnix(tsTx.text.parseInt()) 
  except:
    tsAfTx.text = ""

tsCon.add(tsTx)
tsAfTx.editable=false
tsCon.add(tsAfTx)

con.add(tsLa)
con.add(tsCon)

Win.show()
app.run()
