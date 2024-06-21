# SysInfo : Track system Informations


- This script gathers various system information such as disk usage, RAM usage, processes, IP addresses, last login details, SSH login information, and currently logged-in users.

<img src="/img/output.png" alt="logo"></img>

## Description

The script utilizes several Linux commands to fetch and calculate system metrics, providing a snapshot of the system's current state.


## Prerequisites

Before running the script, ensure you have `bc` installed. If you're using Debian or a Debian-based distribution (like Ubuntu), you can install it with:

```bash
sudo apt-get update
 sudo apt-get install bc
```


## Installation


#### Clone the repository:

```bash
 git clone https://github.com/ciscoAnass/SysInfo
 cd SysInfo
```

#### Make the script executable:

```bash
chmod +x system_info.sh
```

## Running the Script on Every Terminal Launch (Optional)

- If you want the script to run every time you open a terminal session, you can append the script path to ~/.bashrc using the following command:

```bash
echo "~/SysInfo/SysInfo.sh" >> ~/.bashrc
```

- This command appends the path to your script to the end of ~/.bashrc.  

- After appending, source ~/.bashrc to apply the changes:

```bash
source ~/.bashrc
```

- Now, the script will run automatically every time you open a new terminal session.

## Creating a Command Alias

- If you want to create a command alias so you can execute the script by simply typing sysinfo, follow these steps:


```bash
echo "alias sysinfo='~/SysInfo/SysInfo.sh'" >> ~/.bashrc
```

*-Source ~/.bashrc to apply the changes:**

```bash
source ~/.bashrc
```
Now, you can simply type sysinfo in your terminal to run the script.


## Example Output

After running the script, you will see output similar to:

```bash
System Information of <current_date>

Usage of / :             <DiskPer> of <DiskCapacity>
Memory Usage :           <RAM>%
Memory Swap :            <Swap>%
Total Processes :        <Processes>
Root Processes :         <RootProcesses>
IPv4 address  :         <ipv4>
IPv6 address :          <ipv6>
Last Login :            <lastlog>

<ssh_info>

Logged Users :           <LoggedUsers>
```

## Contributing

- Contributions are welcome! Feel free to fork the repository and submit pull requests.










