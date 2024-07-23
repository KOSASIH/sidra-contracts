import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

class SidraAGI:
    def __init__(self):
        self.model = RandomForestClassifier()

    def train_model(self, data):
        # Split the data into training and testing sets
        X_train, X_test, y_train, y_test = train_test_split(data.drop('target', axis=1), data['target'], test_size=0.2, random_state=42)

        # Train the model
        self.model.fit(X_train, y_train)

        # Evaluate the model
        accuracy = self.model.score(X_test, y_test)
        print(f"Model accuracy: {accuracy:.2f}")

    def make_decision(self, data):
        # Make a decision using the trained model
        decision = self.model.predict(data)
        return decision
