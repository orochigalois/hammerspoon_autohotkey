<?php 

file_put_contents("/var/www/html/andrew/score.txt",$_GET['score']);
print $_GET['score'];
