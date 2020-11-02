# Dev, QA, Master enviornment - Will check the 
ENVIORNMENT=''
# Build identifier
BUNDLE_IDENTIFIER=$PRODUCT_BUNDLE_IDENTIFIER
# Name of the Crashlytics GoogleService-Info.plist
FIREBASE_CRASHLYTICS_INFO_PLIST=GoogleService-Info.plist
# Source location from where we have to copy GoogleService-Info.plist
PLIST_LOCATION=''
# Destination location to copy GoogleService-Info.plist
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app

# Bundle ID's
DAME_BUNDLE_ID_DEV=com.dame.dev
DAME_BUNDLE_ID_INT=com.dame.int
DAME_BUNDLE_ID_PROD=com.dame.prod
LITTLEBOY_BUNDLE_ID_DEV=com.littleboy.dev
LITTLEBOY_BUNDLE_ID_INT=com.littleboy.int
LITTLEBOY_BUNDLE_ID_PROD=com.littleboy.prod
MASTER_BUNDLE_ID_DEV=com.master.dev
MASTER_BUNDLE_ID_INT=com.master.int
MASTER_BUNDLE_ID_PROD=com.master.prod

function getEnviornment() {
    local env=$1
    case $env in
        $DAME_BUNDLE_ID_DEV|$LITTLEBOY_BUNDLE_ID_DEV|$MASTER_BUNDLE_ID_DEV)
            ENVIORNMENT='Development'
        ;;
        $DAME_BUNDLE_ID_INT|$LITTLEBOY_BUNDLE_ID_INT|$MASTER_BUNDLE_ID_INT)
            ENVIORNMENT='QA'
        ;;
        $DAME_BUNDLE_ID_PROD|$LITTLEBOY_BUNDLE_ID_PROD|$MASTER_BUNDLE_ID_PROD)
            ENVIORNMENT='Release'
        ;;
        *)
        echo 'Reason for build failure: Use valid bundle identifier. Check firebase.sh at location Crashlytics/'
        exit 1
        ;;
    esac
}

getEnviornment $BUNDLE_IDENTIFIER
PLIST_LOCATION=Crashlytics/${TARGET_NAME}/${ENVIORNMENT}/${FIREBASE_CRASHLYTICS_INFO_PLIST}

if [ -f $PLIST_LOCATION ]
then
    cp "${PLIST_LOCATION}" "${PLIST_DESTINATION}"
    "${PODS_ROOT}/FirebaseCrashlytics/run"
    echo "GoogleService-Info.plist has been copied successfully at ${PLIST_DESTINATION}"
else 
    echo "Reason for build failure: GoogleService-Info.plist is not available at ${PLIST_LOCATION}."
    exit 1
fi
