refresh:
	docker exec -it satis /usr/local/bin/php /satis/bin/satis build /satis.json /output

shell:
	docker exec -it satis bash
