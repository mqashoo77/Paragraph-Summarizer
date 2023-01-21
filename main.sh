while [ $# -ne 1 ] #loop to display the program
do 
printf "\n\tWelcome to Text Sumarization programming 

\tpress 1 to continue ... 

\tpress Any Thing to exit.\t" 


printf " Your choise is " ; read choise # reading user choise if 1 then enter the program anything else exit

if [ $choise == 1 ]
then 
printf "\t"

printf "\tplease enter the name of the text file : " ; read file # read the file name
printf "\tplease enter an integer summary ratio  for example : 1 to 100 : " ; read summ # read the summary ratio

# this function check if the enterd value is less than 1 and more than 100 and not integer will exit
 echo $summ | grep "^[0-9]*$"
    val=`echo $?`
    if [[ $val == 0 ]]
    then
            echo "Given string is intiger"
    
    fi
    echo $summ | grep "^[0-9]*[.][0-9]*$"
    val=`echo $?`
    if [[ $val == 0 ]]
    then
            echo "Given string is float wrong expriton"
            exit 0
    
    fi

   printf " \n "

    dd=$(grep -o "\." test.txt | wc -l) #counting the number of Dot in the sentences
    qq=$(grep -o "?" test.txt | wc -l) #counting the number of ? in the sentences
    rr=$(grep -o "!" test.txt | wc -l) #counting the number of ! in the sentences
    mm=$((dd+qq+rr)) # this is the number of sentences which equal the number of . ? ! in sentences
    echo $mm


       string=$(cat $file) #read the file and store it in a string
       IFS='.!?' # tokenized the sentences
       read -a strarr <<< "$string" #store sentences in array

    #this for loop make the convert to small letter in each sentence and remove duplicat words and remove stopped wordes
       for (( i=0; i<$mm ; i++ ))
    do 
        strarr[i]=$( echo ${strarr[i]} | tr "[:upper:]" "[:lower:]" )
        strarr[i]=$( echo ${strarr[i]} | awk '{for (i=1;i<=NF;i++) if (!string[$i]++)    		printf("%s%s",$i,FS)}{printf("\n")}' )

        strarr[i]=$(echo ${strarr[i]} | sed 's/ i / /g;s/ a / /g;s/ an / /g;s/ as / /g;s/ at / /g;s/ the / /g;s/ by / /g;s/ in / /g;s/ for / /g;s/ of / /g;s/ on / /g;s/ that / /g')
        echo '>'${strarr[i]}
    done

    printf " \n "

    # this nested loop to calculate similirty between each pairs and centrality
    for (( i=0; i<$mm ; i++ ))
    do 
    centerality[$i]=0
    string1=$( echo ${strarr[i]} )

    for (( j=0; j<$mm ; j++ ))
    do
       if [ $j -ne $i ] 
       then
           string2=$( echo ${strarr[j]} )


    string3=($(comm -12 <(echo ${string1[*]}| tr " " "\n"| sort) <(echo ${string2[*]}| tr " " "\n"| sort)| sort -g))


       length1=$( echo ${string1[*]} | wc -w )
       length2=$( echo ${string2[*]} | wc -w )
       inter=$( echo ${string3[*]} | wc -w )

       union=$((length1+length2))
       echo "the number of words between : sent $((i+1)) union sent $((j+1)) is : $union"
       echo "the number of words between :sent $((i+1)) intersection sent  $((j+1)) is : $inter"
    similirity=$( echo "scale=2; $inter / $union" | bc )
    echo "the similirity between sentence $((i+1)) and sentence $((j+1)) is: "
    printf "$similirity\n"

           centerality[$i]=$( echo "scale=2; ${centerality[$i]} + $similirity" | bc )



       fi
    done
    echo "the centrality for sentence $((i+1))is : "
    printf "${centerality[i]}\n"
    done
   
    n1=100
       # this convert the summ to ratio like 50 --->0.5
        summ=$( echo "scale=1; $summ / $n1" | bc )

        n=$( echo " scale=1; $summ * $mm " | bc ) #mul summ with the number of sentence to take the first smalle element of
        #sentence and print them



        a=$(printf "%.0f" $n ) #conver float to int 
        a=$((a/10)) # take the int part
        
        printf " \n \n\n "
        # sort the array of centerality from largest to smallest
        sorted=($(printf '%s\n' "${centerality[@]}"| sort -r -u))
        
    
       
        printf " \n \n\n "
       
        mia=100
     
        
       index1=$( echo ${sorted[4]} )
       
       
      
       
       
       index2=$( printf "${centerality[4]}" )
      
       index2=$( echo " scale=2; $index2 * $mia " | bc )
       index2=$(printf "%.0f" $index2 ) #conver float to int 
       index2=$((index2/10)) # take the int part
      

       
       for (( m=1; m<=$a ; m++ ))
       do  
             index1=$( echo ${sorted[m]} )
             for (( r=0; r<$mm ; r++ ))
             do
	       index2=$( printf "${centerality[r]}" )
	       index2=$( echo " scale=2; $index2 * $mia " | bc )
	       index2=$(printf "%.0f" $index2 ) #conver float to int 
	       index2=$((index2/10)) # take the int part
               
             if [ $index1 -eq $index2 ] 
             then
                  echo '>'${strarr[r]} >> summary.txt
             else
                 continue
             fi
             done
       done

     
              
       
       
       printf "All Done .. Thank You\n" 


    else
        exit 0
    fi
    done
