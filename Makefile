refresh:
	docker compose exec -it satis /usr/local/bin/php /satis/bin/satis build /satis.json /output

shell:
	docker compose exec -it satis bash
