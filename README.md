# chkdskspace
Script checks disk space available and reports via email if the space is below provided threshold.

# chkdskspaceall
Script enumerates all file systems and performs usage check while skipping all tmpfs' and ones with 0% usages.
In turn uses chkdskspace script to send alerts and log outcome.
