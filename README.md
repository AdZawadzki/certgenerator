# certgenerator
Generowanie Certa letsencrypt dla domeny - Przez Dockerfile i instalacja certbota wraz z wywoływanym skryptem


plik cert.Dockerfile - instaluje debiana expose 80 
plik start.sh skrypt pozwalający na wejscie

majac pliki odpalamy komende:

- docker run -it -p 80:80 -d --name cert cert  <<<ten ostatni cert do plik cert.Dockerfile

#wchodzimy do kontenera

- docker exec -it cert bash

#instalacja cerbota
 - apt-get update
 - edytujemy plik /etc/apt/sources.list 
    dodajemy w tym pliku linike:
      deb http://deb.debian.org/debian buster-backports main
      
  - po edycji pliku instalujemy certbota w ten sposob:
   
   apt-get install certbot -t buster-backports
   
   bedac w /etc/apt tworzymy plik o nazwie cert.sh do ktorego wklejmy skrypt generujacy pliki certyfikatu (mozliwe ze 12 lina nie zadziala ale to tylko laczenie sie 2 plikow )
   
   skrypt:
#################################################################################################   
   #!/bin/bash
array=(
example.com            #nazwa domeny
other.example.com
)
all=''
#service haproxy stop
for d in "${array[@]}"
do
        echo "Processing $d..."
        all='-d '$d' '$all
        certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d $d
        cat /etc/letsencrypt/live/$d/fullchain.pem /etc/letsencrypt/live/$d/privkey.pem > /etc/haproxy/certs/$d.pem
done
echo $all
#service haproxy start
####################################################################################################

po zapisaniu nadajemu mu uprawienia wpisujac w konsoli

chmod +x cert.sh

odpalamy skrypt:  ./cert.sh
Przechodzimy instalacje na koncu powinno byc congratulation masz certa.
Pliki z certem sa zapisane w pliku  /etc/letsencrypt/archive/[nazwa domeny]/ 
Pliki z certem nazywają sie odpowiednio : cert1.pem chain1.pem fullchain1.pem privekey1.pem

Robimy pwd zeby miec cala scieszke do plikow w na naszmy przypadku bedzie to 

/etc/letsencrypt/archive/homeluncher.pl


####################################################################################################
Jak mamy pliki to wypadalo by ja skopjowac z tego kontenera do hosta.

Bedac na Hostcie kopjujemy pliki wpisując (kazdy plik trzeba osobno nie mozna wszystkich na raz):


   docker cp cert:/etc/letsencrypt/archive/homeluncher.pl/privkey1.pem  /root/home/certy/
   docker cp cert:/etc/letsencrypt/archive/homeluncher.pl/cert1.pem  /root/home/certy/
   docker cp cert:/etc/letsencrypt/archive/homeluncher.pl/chain1.pem  /root/home/certy/
   docker cp cert:/etc/letsencrypt/archive/homeluncher.pl/fullchain1.pem  /root/home/certy/


ścieszka /root/home/certy/ <--- jest to ścieszka gdzie będą kopiowane pliki do kontenera

Pliki są gotowe do uzytku w postaci instalacji na apache lub nginx





