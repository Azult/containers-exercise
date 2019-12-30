echo "[*] Creating 'unclosed-file' container"

#Some Importent things:
#Please provide the script with user for the container and the c file name
#The user will be created with the default password 'Aa123456'
#In your C code, please use USERID when reffering to the UID you want to change to in setreuid
	#The script will populate this value in your script

user="unclosed"
fileName="unclosed-file" #Without .c

if [ -d "/rootfs/home/$user" ] 
then
	echo "[-] 'unclosed-file' container already exist"
else
    mkdir /rootfs/home/$user
    cp $(echo $0|cut -d '.' -f1)$fileName.c /rootfs/home/$user/$fileName.c
    sed -i "1i#define USERID $(id -u)" /rootfs/home/$user/$fileName.c
    gcc /rootfs/home/$user/$fileName.c -o /rootfs/home/$user/$fileName && chmod u+s /rootfs/home/$user/$fileName
	useradd -s /rootfs/home/$user/$fileName -d /rootfs/home/$user -p Aa123345 $user
	echo "$user:x:$(id -u):$(id -g)::/home/$user/$fileName" >> /home/etc/passwd
fi

