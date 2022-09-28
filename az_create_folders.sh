#!/bin/bash
ACCOUNT_NAME=$1
FS_NAME=$2
FOLDERS_LIST=$3
EXTRA_ACL=$4

#echo ${ACCOUNT_NAME}
#echo ${FS_NAME}
#echo ${FOLDERS_LIST}
#echo ${EXTRA_ACL}

for dir in ${FOLDERS_LIST//,/ };do
  if [ "$(az storage fs directory exists --account-name ${ACCOUNT_NAME} --file-system ${FS_NAME} --name "/${dir}" --only-show-errors | jq -r .exists | tr -d '\n')" = "false" ] ;then
    echo "Folder ${dir} already exists"
    az storage fs directory create --account-name ${ACCOUNT_NAME} --file-system ${FS_NAME} --name "/${dir}" --only-show-errors
    echo "Folder ${dir} created"
  else
    echo "Folder ${dir} already exists"
  fi
  default_acl=$(az storage fs access show --only-show-errors -p "/${FOLDER_NAME}" --account-name ${ACCOUNT_NAME} -f ${FS_NAME} | jq -r .acl | egrep -o "(default:)?(group|user|mask|other)::[rwx-]{3}" | uniq | sed -e 's/\(.*\)/\1,/' | tr -d '\n' | sed -e 's/,$//')
  echo "Setting ACL='${default_acl}${EXTRA_ACL}' for folder ${dir}"
  az storage fs access set-recursive --only-show-errors -p "/${FOLDER_NAME}" --account-name ${ACCOUNT_NAME} -f ${FS_NAME} --acl "${default_acl}${EXTRA_ACL}"
done
