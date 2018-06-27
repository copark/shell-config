# /etc/profile.d/
alias pscpu='ps -eo s,pid,ucmd:12,time,cp,etime,pmem --sort=-time,-cp | head' 
alias psmem='ps -eo s,pid,ucmd:12,cp,etime,pmem,rss,pcpu --sort=-pmem,-rss | head' 
alias pstree='pstree -np'
alias enus='export LANG=en_US.UTF-8'
? () { echo "$*" | bc -l; }
