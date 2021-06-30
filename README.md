Git prompt builder script for `tcsh`.  
Shows branch name and it's status. Similar to [`posh-git`](https://github.com/dahlbyk/posh-git).

Generated prompt looks like this:  
![image](https://user-images.githubusercontent.com/28982082/123982864-0d063b00-d9cc-11eb-9ea7-f7817d2ece4a.png)

Status summary has the following format:  
`[{HEAD-name} S +A ~B -C !D | +E ~F -G]`  
`S` = branch status in relation with remote  
`ABCD` - files modified in work dir (red)  
`EFG`  - files modified in index (green)  
