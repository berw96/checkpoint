import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# \t delimeter specifies TAB. Used for TSV (Tab Separated Values) files.
# Setting quoting to 3 prevents our model from acknowledging quotation marks.
data = pd.read_csv(
    filepath_or_buffer = "test data/Restaurant_Reviews.tsv", 
    delimiter = '\t',
    quoting = 3
    )

import re
import nltk

# Download stopwords
nltk.download('stopwords')
# Import stopwords
from nltk.corpus import stopwords
# Applies stemming to words in reviews.
from nltk.stem.porter import PorterStemmer
# Stores cleaned reviews.
corpus = []

for i in range(0, len(data.iloc[:,0])):
    # Filter punctuation out of reviews.
    review = re.sub('[^a-zA-Z]',' ' , data['Review'][i])
    # Convert all letters to lower-case.
    review = review.lower()
    # Split review in to constituent words
    review = review.split()
    
    # Stemming
    ps = PorterStemmer()
    all_stopwords = stopwords.words('english')
    # Include 'not' as an informative word.
    all_stopwords.remove('not')
    
    review = [ps.stem(word) for word in review if not word in set(all_stopwords)]
    review = ' '.join(review)
    corpus.append(review)

print(corpus)

# Tokenization
from sklearn.feature_extraction.text import CountVectorizer
# Take the most frequent words.
cv = CountVectorizer(max_features = 1500)
x = cv.fit_transform(corpus).toarray()
y = data.iloc[:,-1].values

# Create training set and test set.
from sklearn.model_selection import train_test_split
x_train, y_train, x_test, y_test = train_test_split(x, y, test_size = 0.2, random_state = 0)

# Train Naive Bayes model using training set.
from sklearn.naive_bayes import GaussianNB
gnb_model = GaussianNB()
gnb_model.fit(x_train, y_train)

# Generate predictions on test data using trained model.
y_predictions = gnb_model.predict(x_test)

# Generate confusion matrix to analyse model accuracy.
from sklearn.metrics import confusion_matrix, accuracy_score
cm = confusion_matrix(y_test, y_predictions)
print(confusion_matrix)
accuracy_score(y_test, y_predictions)



