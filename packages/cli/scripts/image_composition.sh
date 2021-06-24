#!/bin/sh

# pngquantについて
i=1
while [ ${i} -ne 17 ]
do
    j=1
    while [ ${j} -ne 17 ]
    do
        k=1
        while [ ${k} -ne 13 ]
        do

            # convert +append type1/res_type1_1`printf "%02d" ${i}`.png type2/res_type2_2`printf "%02d" ${j}`.png type3/res_type3_3`printf "%02d" ${k}`.png tmp/res_type_`printf "%02d" ${i}`_`printf "%02d" ${j}`_`printf "%02d" ${k}`.png
            # pingquant tmp/res_type_`printf "%02d" ${i}`_`printf "%02d" ${j}`_`printf "%02d" ${k}`.png

	        # convert -append title_1.png pre/res_type_`printf "%02d" ${i}`_`printf "%02d" ${j}`.png tmp/motif/1/res_type_`printf "%02d" ${i}`_`printf "%02d" ${j}`.png
	        # convert -append title_2.png pre/res_type_`printf "%02d" ${i}`_`printf "%02d" ${j}`.png tmp/motif/2/res_type_`printf "%02d" ${i}`_`printf "%02d" ${j}`.png
        k=`expr ${k} + 1`
        done

    j=`expr ${j} + 1`
    done

i=`expr ${i} + 1`
done
