docker build -t vulnforum .
docker run -d -p 8080:80 --name vuln_forum --network thesis2-network-1 vulnforum
# docker run -p 8080:80 --name vuln_forum --network thesis2-network-1 --rm vulnforum
docker stop vuln_forum && docker rm vuln_forum && docker build -t vulnforum . && docker run -d -p 8080:80 --name vuln_forum --network thesis2-network-1 vulnforum

docker exec -it vuln_forum bash
mysql -u root -p


docker run -d --name nessus -p 8834:8834 -e "ACTIVATION_CODE=6H4W-8EBB-PE2W-FGZJ-PU69" -e "USERNAME=admin" -e "PASSWORD=password" tenable/nessus:latest-ubuntu

# docker run -u zap -p 8081:8080 --network thesis2-network-1 -i owasp/zap2docker-stable zap-full-scan.py -t http://vuln_forum -r report.html -I -j -J -z "-config scanner.attackOnStart=true -config scanner.level=HIGH -config scanner.threadPerHost=10"


# docker run -u zap -p 8081:8080 --network thesis2-network-1 -v zap-reports:/zap/wrk -i zaproxy/zap-stable zap-full-scan.py -t http://vuln_forum -r report.html -I -j -J -z "-config scanner.attackOnStart=true -config scanner.level=HIGH -config scanner.threadPerHost=10"
docker run -u zap -p 8081:8080 --network thesis2-network-1 --volume zap-reports:/zap/wrk -i zaproxy/zap-stable zap-full-scan.py -t http://vuln_forum -r report.html -I -j -J -z "-config scanner.attackOnStart=true -config scanner.level=HIGH -config scanner.threadPerHost=10"
