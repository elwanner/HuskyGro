# Project Overview

We have developed a Flask grocery store application that facilitates a customer's shopping experience and also provides store management functionality for employees. With our application, a customer can view product information, such as what products are in stock and what aisle a product is in, and can also place orders online. Employees are able to view similar information about products in order to help customers, can service orders that customers placed online, and can add or delete prodcuts from inventroy. Our application uses Appsmith to generate front-end UI pages that customers and employees can interact with. Our application also uses MySQL to persist data (inventory, customer order, etc.,).  

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 




