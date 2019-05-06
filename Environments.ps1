####################################################
######           Helper Functions             ######
####################################################

function createUrl ([String] $PARAMETER_PROTOCOL, [String] $PARAMETER_HOSTNAME, [String] $PARAMETER_PORT, [String] $PARAMETER_PATH) {
    return $PARAMETER_PROTOCOL + "://" + $PARAMETER_HOSTNAME + ":" + $PARAMETER_PORT + "/" + $PARAMETER_PATH
}

##############################################################
###### Customer - Example Environment - Web Services    ######
##############################################################

$URL_PROTOCOL = "https"
$URL_HOSTNAME = "appurl.com"
$URL_PORT = "443"
$URL_PATH = "webservices-endpoint"

$DEV1_WEBSERVICES = createUrl $URL_PROTOCOL $URL_HOSTNAME $URL_PORT $URL_PATH
$DEV1_WEBSERVICES

###################################################################
###### Customer - Example Environment - Frontend Application ######
###################################################################

$URL_PROTOCOL = "https"
$URL_HOSTNAME = "appurl.com"
$URL_PORT = "443"
$URL_PATH = "frontend-application"

$DEV1_FRONTEND = createUrl $URL_PROTOCOL $URL_HOSTNAME $URL_PORT $URL_PATH
$DEV1_FRONTEND