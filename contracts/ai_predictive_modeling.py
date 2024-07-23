import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split

class AIPredictiveModeling:
    def __init__(self):
        self.model = RandomForestRegressor()

    def train_model(self, data):
        # Split the data into training and testing sets
        X_train, X_test, y_train, y_test = train_test_split(data.drop('target', axis=1), data['target'], test_size=0.2, random_state=42)

        # Train the model
        self.model.fit(X_train, y_train)

        # Evaluate the model
        accuracy = self.model.score(X_test, y_test)
        print(f"Model accuracy: {accuracy:.2f}")

    def make_prediction(self, data):
        # Make a prediction using the trained model
        prediction = self.model.predict(data)
        return prediction
