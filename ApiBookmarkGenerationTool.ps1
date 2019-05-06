function generateBookmarkHtml([Hashtable] $bookmarkHashtable, [String] $outFile)
{
    $bookmarkHtml = New-Object System.Collections.ArrayList
    $bookmarkHtml += "<!DOCTYPE NETSCAPE-Bookmark-file-1>"
    $bookmarkHtml += "<!-- This is an automatically generated file."
    $bookmarkHtml += "     It will be read and overwritten."
    $bookmarkHtml += "     DO NOT EDIT! -->"
    $bookmarkHtml += "<META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; charset=UTF-8"">"
    $bookmarkHtml += "<TITLE>Bookmarks</TITLE>"
    $bookmarkHtml += "<H1>Bookmarks</H1>"
    $bookmarkHtml += "<DL>"
    $bookmarkHtml += "<DT><H3 PERSONAL_TOOLBAR_FOLDER=""true"">Bookmarks</H3></DT>"
    $bookmarkHtml += "<DL>"
    $bookmarkHtml += unloadBookmarkHashtable $bookmarkHashtable
    $bookmarkHtml += "</DL>"
    $bookmarkHtml += "</DL>"
    
    $bookmarkHtml > $outFile
    
    [System.Io.File]::ReadAllText($outFile) | Out-File -FilePath $outFile -Encoding Ascii
}

function unloadBookmarkHashtable([Hashtable] $bookmarkHashtable)
{
    $bookmarkHtml = New-Object System.Collections.ArrayList

    foreach ($bookmarkTitle in $bookmarkHashtable.Keys) {
        
        $bookmarkItem = $bookmarkHashtable.$bookmarkTitle

        if($bookmarkItem.GetType().Name -eq "String")
        {
            $bookmarkUrl = $bookmarkItem;
            $bookmarkHtml += "<DT><A HREF=""$bookmarkUrl"">$bookmarkTitle</A></DT>"
        }

        if($bookmarkItem.GetType().Name -eq "Hashtable")
        {
            $bookmarkFolder = $bookmarkItem;
            $bookmarkHtml += "<DT><H3>$bookmarkTitle</H3></DT>"
            
            $bookmarkHtml += "<DL>"
            $bookmarkHtml += unloadBookmarkHashtable $bookmarkFolder
            $bookmarkHtml += "</DL>"
        }
    }

    return $bookmarkHtml
}

#Constants for Usage
$FRONTEND_CONSTANT = "Application"
$WEBSERVICES_CONSTANT = "WebServices"

function createWebsiteHashtable([String] $FRONTEND_PARAMETER, [String] $WEBSERVICES_PARAMETER)
{
    [Hashtable] $hashtableToReturn = @{}
    $hashtableToReturn.Add($FRONTEND_CONSTANT, $FRONTEND_PARAMETER)
    $hashtableToReturn.Add($WEBSERVICES_CONSTANT, $WEBSERVICES_PARAMETER)
    return $hashtableToReturn
}

function create_Bookmark_Hashtable([Hashtable] $ENVIRONMENT_HASHTABLE, [System.Collections.ArrayList] $WEBSERVICES_LIST, [System.Collections.ArrayList] $ACTIONS_LIST, [String] $ADDITIONAL_PARAMETERS)
{
    [Hashtable] $hashtableToReturn = @{}

    foreach ($environment in $ENVIRONMENT_HASHTABLE.Keys) 
    {
        [Hashtable] $hashtableToAdd = @{}
    
        $WebsiteHashtable = $ENVIRONMENT_HASHTABLE.$environment
    
        foreach($frontendWebservicesValue in $WebsiteHashtable.Keys)
        {
            if($frontendWebservicesValue -eq $FRONTEND_CONSTANT)
            {
                $FRONTEND_URL = $WebsiteHashtable.$frontendWebservicesValue
                $hashtableToAdd.Add($FRONTEND_CONSTANT, $FRONTEND_URL)
            }
    
            if($frontendWebservicesValue -eq $WEBSERVICES_CONSTANT)
            {
                [Hashtable] $hashtableToAdd_Services = @{}

                $WEBSERVICES_URL = $WebsiteHashtable.$frontendWebservicesValue
                
                foreach($SERVICE in $WEBSERVICES_LIST)
                {
                    [Hashtable] $hashtableToAdd_Services_Instance = @{}

                    foreach($ACTION in $ACTIONS_LIST)
                    {
                        [String] $WEBSERVICES_QUERY_STRING = "$WEBSERVICES_URL" + "/" + "$SERVICE" + "?" + "$ACTION" + "$ADDITIONAL_PARAMETERS"
                        Write-Host $WEBSERVICES_QUERY_STRING
                        $hashtableToAdd_Services_Instance.Add($ACTION, $WEBSERVICES_QUERY_STRING)
                    }

                    $hashtableToAdd_Services.Add($SERVICE, $hashtableToAdd_Services_Instance)
                }

                $hashtableToAdd.Add($WEBSERVICES_CONSTANT, $hashtableToAdd_Services)
            }
        }

        $hashtableToReturn.Add($environment, $hashtableToAdd)
    }

    return $hashtableToReturn
}