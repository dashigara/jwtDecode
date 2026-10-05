import std/[os, base64, json, strutils]

func splitToken(input: string): 
  tuple[header: string, payload: string, signature: string]
  {.raises: [ValueError].} = 
  ## JWTを分割
  let token = input.strip()
  let datas = token.split('.')
  if datas.len >= 3:
    return (datas[0], datas[1], datas[2])
  else:
    raise newException(ValueError, "Invalid Format")

proc dec2Json(bstr: string): string =
  ## Base64の各部位をフォーマットされたJSONに変換
  return bstr
    .decode()
    .parseJson()
    .pretty()

proc jwtDec(token: string):
  tuple[header: string, payload: string, signature: string] = 
  let (header, payload, signature) = token.splitToken()
  return (header.dec2Json(), payload.dec2Json(), signature)
  

when isMainModule:
  if paramCount() < 1:
    quit "jwtDec [token]", 1

  let token = paramStr(1)
  let (header, payload, signature) = jwtDec(token)

  echo "\e[31m==================== header =====================\e[0m"
  echo header
  echo "\e[32m==================== payload ====================\e[0m"
  echo payload
  echo "\e[33m=================== signature ===================\e[0m"
  echo signature


