# BloodHound GUI
alias bloodhoundg="/home/gladwin/tools/packages/BloodHound/BloodHound-linux-x64/BloodHound --no-sandbox"

# Neo4J
alias neo4j="docker run     --restart always     --publish=7474:7474 --publish=7687:7687     --env NEO4J_AUTH=neo4j/supersecure    --name=neo4j     --volume=/home/gladwin/.local/share/data:/data     neo4j:5.25.1"

# clipboard alias
alias clipboard="xclip -selection clipboard"

# neovim
alias vim="/usr/bin/nvim"
