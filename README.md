### Scatter - The Source port NCATTER

This is a super niche tool for those of us that find ourselves repeatedly adding the same ncat source port manipulation statements, for example, when working on obscure pivoting exercises. In esssence, what it does, is take a list of this mappings and apply them for you.  
Beyond this, it will also at first run see if you have any current ncats, and offer you the opportunity to mercilessly kill them.  
The mappings file is fairly basic, but say for example we wanted to listen locally on 3389, then forward that to a target of 10.10.10.10:3389, but ensuring we always used a source port of 53 we could use the following ncat string:  
**> ncat -k -l -p 3389 -c 'ncat 10.10.10.10 3389 -p53'.**  
Alternatively, we could just add it to the scatter mappings file like this:  
**> 3389:10.10.10.10:3389:53**

Now it will always be there when we need it. It also allows us to quickly execute hundreds of NCATS at any one time by expanding on this list, to build up a much more usable way of running basic scans against remote hosts. This is obviously limited by your local port space, but can still be useful in specific scenarios.

##Notes
-Tested only on Kali, Mac support later  
-Ensure you create your own mappings file, mine is just an example.  
-Tested on Ruby 2.5
