#! /bin/bash 

LOG_FILE='/var/log/kindle-log.log'
EMAIL_ADDRESS=${KINDLE_EMAIL_ADDRESS}
TAGS_FILTER=${KINDLE_TAGS_FILTER}

cd /home/ubuntu
source /home/ubuntu/wallakindle/bin/activate


echo "----------- Start $(date +"%Y-%m-%d %H:%M:%S.%3N%z") ------------" 

# Getting list of unread articles
echo "  Fetching articles..."
articles=$(/home/ubuntu/wallakindle/bin/activate && wallabag --config /home/ubuntu/config.ini list -n --tags ${TAGS_FILTER})
echo "  Fetched."

# Checking the article lines
article_list=($articles)

for article_info in "${article_list[@]}"; do
	article_info_split=($article_info)
	id=${article_info_split[0]}

	echo "  checking an id"

	# Valid id?
	if [[ $id =~ ^[0-9]+$ ]]; then
		echo "    Valid article id ${id}. Converting to epub..." 

		# exporting the article in epub format
		wallabag --config /home/ubuntu/config.ini export --format epub "$id"

		echo "    Converted." 

		epub_file_path=$(find . -maxdepth 1 -name "$id*" -type f)
		epub_file=$(basename "$epub_file_path")
	
		echo "    Sending epub $epub_file..."
		mutt -F /root/.muttrc -s "New article: $url" -a "$epub_file" -- "$EMAIL_ADDRESS" < /dev/null && wallabag --config /home/ubuntu/config.ini read "$id"
	
		echo "    Sent."

		echo "    Clean file ${epub_file}"

		# Cleansing files
		rm "$epub_file"

		echo "    Done."
	else
		echo "    Invalid id. Ignored."
		continue
	fi

	echo "  done with ${id}."
done

echo "----------- Done -----------"
