# BloodHound GUI
alias bloodhoundg="/home/gladwin/tools/packages/BloodHound/BloodHound-linux-x64/BloodHound --no-sandbox"

# Neo4J
alias neo4j="docker run     --restart always     --publish=7474:7474 --publish=7687:7687     --env NEO4J_AUTH=neo4j/supersecure    --name=neo4j     --volume=/home/gladwin/.local/share/data:/data     neo4j:5.25.1"

# clipboard alias
alias clipboard="xclip -selection clipboard"

# neovim
alias vim="/usr/bin/nvim"

#TODO --> move to education aliases
alias mountedu="/usr/bin/vmhgfs-fuse .host:/ $HOME/shares -o subtype=vmhgfs-fuse"
alias ict1531core1="zathura --fork \"$HOME/Documents/UNISA/ICT1531/CompTIA A+ Core 2 Certification/Meyers M. Mike Meyers' CompTIA A+ Core 1 Certification Passport...2023.pdf\""
alias ict1531core2="zathura --fork \"$HOME/Documents/UNISA/ICT1531/CompTIA A+ Core 2 Certification/Meyers M. Mike Meyers' CompTIA A+ Core 2 Certification Passport...2023.pdf\""
alias ict1532="zathura --fork \"$HOME/Documents/UNISA/ICT1532/CompTIA Network+ Certification All-in-One Exam Guide, 8th Edition/CompTIA Network+ Certification All-in-One Exam Guide, 8th Edition/CompTIA Network+ Certification All-in-One Exam Guide, 8th Edition.epub\""
alias ict1513="zathura --fork \"$HOME/Documents/UNISA/ICT1513/Minnick J. Responsive Web Design with HTML 5 and CSS 9ed 2021/Minnick J. Responsive Web Design with HTML 5 & CSS 9ed 2021.pdf\""
alias ict1511="zathura --fork \"$HOME/Documents/UNISA/ICT1511/Farrel J. Programming Logic and Design 10ed 2024/Farrel J. Programming Logic and Design 10ed 2024.pdf\""
