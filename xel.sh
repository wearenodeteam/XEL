
#!/bin/bash

# Color Variables
CYAN="\033[0;36m"
NC="\033[0m" # No Color
INFO="\033[0;32m"
ERROR="\033[0;31m"
SUCCESS="\033[0;32m"
WARN="\033[0;33m"

# Display a message after logo
echo -e "${CYAN}🎉 Displaying Aniani!!! ${NC}"

# Display logo directly from URL
echo -e "${CYAN}✨ Displaying logo... ${NC}"
wget -qO- https://raw.githubusercontent.com/Chupii37/Chupii-Node/refs/heads/main/Logo.sh | bash

# Update and upgrade system packages
echo -e "${INFO}🔄 Updating and upgrading packages... ${NC}"
sudo apt update && sudo apt upgrade -y

# Check if Docker is installed
echo -e "${INFO}🔍 Checking Docker installation... ${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${ERROR}🚫 Docker not found. Installing Docker... ${NC}"
    
    # Install Docker
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo -e "${SUCCESS}✔️ Docker successfully installed! ${NC}"
else
    echo -e "${SUCCESS}✔️ Docker is already installed. ${NC}"
fi

# Clean up unnecessary packages
echo -e "${INFO}🧹 Cleaning up unnecessary packages... ${NC}"
sudo apt-get autoremove -y
sudo apt-get clean
echo -e "${SUCCESS}✅ Unnecessary packages removed! ${NC}"

# Prompt user to enter wallet address
echo -e "${CYAN}💸 Enter your wallet address: ${NC}"
read address

# Choose server pool
echo -e "${CYAN}🌐 Choose your server pool: ${NC}"
echo "a. Singapore"
echo "b. China Hong Kong"
echo "c. Asia Korea"
echo "d. Australia Sydney"
echo "e. France Gravelines"
echo "f. Germany Frankfurt"
echo "g. Ukraine Kiev"
echo "h. Finland Helsinki"
echo "i. Romania Bucharest"
echo "j. Poland Warsaw"
echo "k. Kazakhstan Almaty"
echo "l. USA (West) California"
echo "m. USA (North East) Ohio"
echo "n. Turkey Istanbul"
echo "o. USA (South East) Georgia"
echo "p. USA (South West) Texas"
echo "q. Canada Montreal"
echo "r. Russia Moscow"
echo "s. South America Brazil"
read server_choice

# Prompt user to choose mining pool or solo pool
echo -e "${CYAN}💎 Choose pool type: ${NC}"
echo "a. Xelis Pool"
echo "b. Xelis Solo"
read pool_type

# Map server choice to pool addresses based on pool type
if [[ "$pool_type" == "a" ]]; then
    # Xelis Pool addresses
    case $server_choice in
        a) pool="stratum+ssl://sg.vipor.net:5177" ;;
        b) pool="stratum+ssl://cn.vipor.net:5177" ;;
        c) pool="stratum+ssl://ap.vipor.net:5177" ;;
        d) pool="stratum+ssl://au.vipor.net:5177" ;;
        e) pool="stratum+ssl://fr.vipor.net:5177" ;;
        f) pool="stratum+ssl://de.vipor.net:5177" ;;
        g) pool="stratum+ssl://ua.vipor.net:5177" ;;
        h) pool="stratum+ssl://fi.vipor.net:5177" ;;
        i) pool="stratum+ssl://ro.vipor.net:5177" ;;
        j) pool="stratum+ssl://pl.vipor.net:5177" ;;
        k) pool="stratum+ssl://kz.vipor.net:5177" ;;
        l) pool="stratum+ssl://usw.vipor.net:5077" ;;
        m) pool="stratum+ssl://us.vipor.net:5077" ;;
        n) pool="stratum+ssl://tr.vipor.net:5077" ;;
        o) pool="stratum+ssl://usse.vipor.net:5077" ;;
        p) pool="stratum+ssl://ussw.vipor.net:5077" ;;
        q) pool="stratum+ssl://ca.vipor.net:5077" ;;
        r) pool="stratum+ssl://ru.vipor.net:5077" ;;
        s) pool="stratum+ssl://sa.vipor.net:5077" ;;
        *) echo -e "${ERROR}🚫 Invalid server choice. Exiting. ${NC}" && exit 1 ;;
    esac
elif [[ "$pool_type" == "b" ]]; then
    # Xelis Solo addresses
    case $server_choice in
        a) pool="stratum+ssl://sg.vipor.net:5178" ;;
        b) pool="stratum+ssl://cn.vipor.net:5178" ;;
        c) pool="stratum+ssl://ap.vipor.net:5178" ;;
        d) pool="stratum+ssl://au.vipor.net:5178" ;;
        e) pool="stratum+ssl://fr.vipor.net:5178" ;;
        f) pool="stratum+ssl://de.vipor.net:5178" ;;
        g) pool="stratum+ssl://ua.vipor.net:5178" ;;
        h) pool="stratum+ssl://fi.vipor.net:5178" ;;
        i) pool="stratum+ssl://ro.vipor.net:5178" ;;
        j) pool="stratum+ssl://pl.vipor.net:5178" ;;
        k) pool="stratum+ssl://kz.vipor.net:5178" ;;
        l) pool="stratum+ssl://usw.vipor.net:5178" ;;
        m) pool="stratum+ssl://us.vipor.net:5178" ;;
        n) pool="stratum+ssl://tr.vipor.net:5178" ;;
        o) pool="stratum+ssl://usse.vipor.net:5178" ;;
        p) pool="stratum+ssl://ussw.vipor.net:5178" ;;
        q) pool="stratum+ssl://ca.vipor.net:5178" ;;
        r) pool="stratum+ssl://ru.vipor.net:5178" ;;
        s) pool="stratum+tcp://sa.vipor.net:5178" ;;
        *) echo -e "${ERROR}🚫 Invalid server choice. Exiting. ${NC}" && exit 1 ;;
    esac
else
    echo -e "${ERROR}🚫 Invalid pool type. Exiting. ${NC}"
    exit 1
fi

# Prompt user to enter worker name
echo -e "${CYAN}🧑‍💻 Enter your worker name: ${NC}"
read worker_name

# Ask for CPU usage
echo -e "${CYAN}💻 Enter the number of CPUs you want to use (example: 2 for 2 CPUs): ${NC}"
read cpu_count
cpu_count=${cpu_count:-1}  # Default to 1 if empty
if ! [[ "$cpu_count" =~ ^[0-9]+$ ]]; then
    echo -e "${ERROR}🚫 Invalid input for CPU count. Please enter a number. ${NC}"
    exit 1
fi

cpu_devices=""
for ((i=0; i<cpu_count; i++)); do
    cpu_devices="--cpu $i $cpu_devices"
done

# Check if directory exists, create if not
echo -e "${INFO}📂 Checking directory... ${NC}"
if [ -d "xelis-docker" ]; then
  echo -e "${INFO}📂 Directory 'xelis-docker' already exists. ${NC}"
else
  mkdir vipor-docker
  echo -e "${SUCCESS}✅ Directory 'xelis-docker' created successfully! ${NC}"
fi

# Change to the directory
cd xelis-docker

# Get public IP address
public_ip=$(curl -s ifconfig.me)
if [ -z "$public_ip" ]; then
  echo -e "${ERROR}🚫 Failed to retrieve public IP address. Exiting. ${NC}"
  exit 1
fi

# Create Dockerfile with user input
echo -e "${INFO}📝 Creating Dockerfile... ${NC}"
cat <<EOL > Dockerfile
# Using the latest Ubuntu as the base image
FROM ubuntu:22.04

# Install necessary tools
RUN apt-get update && apt-get install -y \\
    wget \\
    tar

WORKDIR /xelis-docker

# Download and extract hellminer
RUN wget https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64.tar.gz && \\
    tar -xvzf hellminer_linux64.tar.gz && \\
    chmod +x hellminer && \\
    rm hellminer_linux64.tar.gz

# Run the miner with provided parameters
CMD ["/bin/bash", "-c", "./hellminer -c $pool -u $address.$worker_name -p x $cpu_devices"]
EOL

# Set container name and build the image
container_name="xelis-docker"
echo -e "${INFO}⚙️ Building Docker image... ${NC}"
docker build -t $container_name .

# Run the Docker container
echo -e "${INFO}🚀 Running Docker container... ${NC}"
docker run -d --name $container_name --restart unless-stopped -v /usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu $container_name

# Success message with emojis
echo -e "${SUCCESS}🎉🚀✨ Your Docker container is now running with automatic restart enabled! ${NC}"
echo -e "${INFO}🔍 To view the logs in real-time, run the following command: ${NC}"
echo -e "${INFO}docker logs -f $container_name ${NC}"
