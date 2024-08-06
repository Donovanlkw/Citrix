
### --- Generate API Authentication Token
https://github.com/settings/tokens/new

$myToken = ""
$authHeader = @{Authorization = "bearer $My_token"}
$URL = "https://api.github.com/users/donovanlkw"


invoke-restmethod -Uri $URL
invoke-restmethod -Uri $URL -hteaders $authHeader

