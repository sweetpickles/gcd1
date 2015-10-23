# read in training data
# note: bind columns with activity and subject info
trn = cbind(read.table('./UCI HAR Dataset/train/subject_train.txt'),
            read.table('./UCI HAR Dataset/train/y_train.txt'),
            read.table('./UCI HAR Dataset/train/X_train.txt'))

# read in test data, same note as above
tst = cbind(read.table('./UCI HAR Dataset/test/subject_test.txt'),
            read.table('./UCI HAR Dataset/test/y_test.txt'),
            read.table('./UCI HAR Dataset/test/X_test.txt'))

# combine train and test
tt = rbind(trn,tst)

# add in the features labels
features = read.table('./UCI HAR Dataset/features.txt')
colnames(tt) = c('Subject','Activity',t(features)[2,])

# subset to include only means and stdevs
# note: meanFreq data was excluded
tt2 = cbind(tt[grepl('mean()',colnames(tt),fixed=TRUE)],tt[grepl('std()',colnames(tt),fixed=TRUE)])

# add the subject and activity columns back in
# note probably a better way to do this?
tt2$Subject = tt$Subject
tt2$Activity = tt$Activity

# add activity label info to make data easier to read
actlbl = read.table('./UCI HAR Dataset/activity_labels.txt')
actlbl2 = actlbl$V2
tt2$Activity = actlbl2[tt2$Activity]

# summarize the data based on subject and activity, taking mean of each measurement
tt3 = aggregate(. ~ Subject + Activity,data=tt2,mean)

# take out the extraneous activity field
# tt4 = tt3[,1:68]

# output to text file
write.table(tt3,file='gcd02.txt',row.names=FALSE)
