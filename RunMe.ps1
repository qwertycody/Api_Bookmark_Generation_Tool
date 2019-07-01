#######################################################
###### Setup/Import Statements for API Functions ######
#######################################################
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

. .\Environments.ps1
. .\ApiBookmarkGenerationTool.ps1

#######################################################
######             Setup Variables               ######
#######################################################

#Comma Delimitted List of WebService Endpoints
$WEBSERVICES = "Endpoint1,Endpoint2"
[System.Collections.ArrayList] $WEBSERVICES_LIST = $WEBSERVICES.Split(",");

#Actions that can be taken on the endpoint on the Query portion of the url
$WEBSERVICE_ACTIONS = "ExampleAction1,ExampleAction2"
[System.Collections.ArrayList] $WEBSERVICES_ACTIONS_LIST = $WEBSERVICE_ACTIONS.Split(",");

##########################################################################
###### Main Methods - Add your environments and hostname urls here  ######
##########################################################################

[Hashtable] $ENVIRONMENT_HASHTABLE = @{}
$ENVIRONMENT_HASHTABLE.Add("Dev1", (createWebsiteHashtable $DEV1_FRONTEND $DEV1_WEBSERVICES))

#######################################################
######             Create Bookmark File          ######
#######################################################

[Hashtable] $BOOKMARK_HASHTABLE = @{}

$ADDITIONAL_PARAMETERS=""

$BOOKMARK_HASHTABLE.Add("API Debugging",(create_Bookmark_Hashtable $ENVIRONMENT_HASHTABLE $WEBSERVICES_LIST $WEBSERVICES_ACTIONS_LIST $ADDITIONAL_PARAMETERS))
generateBookmarkHtml $BOOKMARK_HASHTABLE "bookmarks.html"
