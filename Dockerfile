# Use official Node.js image as the base image
FROM node:14

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port that the Medusa server will run on
EXPOSE 9000

# Start the Medusa backend server
CMD ["npm", "run", "start"]
