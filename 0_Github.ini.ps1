
### --- Generate API Authentication Token
https://github.com/settings/tokens/new

$myToken = ""
$authHeader = @{Authorization = "bearer $My_token"}
$URL = "https://api.github.com/users/donovanlkw"


invoke-restmethod -Uri $URL
invoke-restmethod -Uri $URL -hteaders $authHeader


https://github.com/microsoft/powershellforgithub.
$module_Name = "PowershellforGitHub"


get-command -module powershellforgithub
get-command -module powershellforgithub | out-gridview

set-GitHubAuthentication -sessiononly

$token = 

get-
