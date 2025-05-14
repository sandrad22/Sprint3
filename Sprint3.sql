USE transactions;

# Descripció
# En aquest sprint, es simula una situació empresarial en la qual has de realitzar diverses manipulacions en les taules de la base de dades. Al seu torn, hauràs de treballar amb índexs i vistes. 
# En aquesta activitat, continuaràs treballant amb la base de dades que conté informació d'una empresa dedicada a la venda de productes en línia. 
# En aquesta tasca, començaràs a treballar amb informació relacionada amb targetes de crèdit.


# NIVELL 1

# Exercici 1
# La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
# La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
# Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.


CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(15) PRIMARY KEY,
    iban VARCHAR(35),
    pan VARCHAR(25),
    pin VARCHAR(4),
    cvv VARCHAR(3),
    expiring_date VARCHAR(8)
    );
  
# EJECUTAR "datos_introducir_credit.sql"


ALTER TABLE transaction
ADD FOREIGN KEY(credit_card_id) REFERENCES credit_card(id);



# Exercici 2
# El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
# La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card
SET iban='R323456312213576817699999'
WHERE id = 'CcU-2938';


SELECT id, iban
FROM credit_card
WHERE id = 'CcU-2938';


# Exercici 3
# En la taula "transaction" ingressa un nou usuari amb la següent informació:
# Id 108B1D1D-5B23-A76C-55EF-C568E49A99DD, credit_card_id CcU-9999, company_id b-9999, user_id 9999, lat 829.999, longitude -117.999, amount 111.11, declined 0

INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);


# Exercici 4
# Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP COLUMN pan;

SHOW COLUMNS
FROM credit_card;



# NIVELL 2

# Exercici 1
# Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.

DELETE FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT id
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';


# Exercici 2
# La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
# Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
# Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.


#DROP VIEW VistaMarketing;


CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, AVG(amount) AS MediaCompañia
FROM transaction t, company c
WHERE t.company_id = c.id AND t.declined = 0
GROUP BY company_name, phone, country;

SELECT *
FROM VistaMarketing
ORDER BY MediaCompañia DESC;


# Exercici 3
# Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT *
FROM VistaMarketing
WHERE country = 'Germany';



# NIVELL 3

# Exercici 1
# La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
# Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

# Recordatori
# En aquesta activitat, és necessari que descriguis el "pas a pas" de les tasques realitzades. És important realitzar descripcions senzilles, simples i fàcils de comprendre. 
# Per a realitzar aquesta activitat hauràs de treballar amb els arxius denominats "estructura_dades_user" i "dades_introduir_user"

####### Explicar de donde partimos, como es actualmente el esquema y lo que queremos conseguir

####### EJECUTAR "estructura_datos_user.sql" 

####### AL CREAR LA TABLA user TAL Y COMO ESTÁ EN "estructura_datos_user.sql" LA FOREIGN KEY DE user SE CREA AL REVÉS, YA QUE INDICA QUE 1 TRANSACCION PODRIA SER HECHA POR MUCHOS USUARIOS, 
####### EN LUGAR DE QUE 1 USUARIO PUEDE HACER MUCHAS TRANSACCIONES, ASÍ QUE ELIMINAMOS LA TABLA user PARA VOLVERLA A CREAR CORRECTAMENTE


# Elimino la foreign key de la tabla user

ALTER TABLE user
DROP FOREIGN KEY user_ibfk_1;


# EJECUTAR "datos_introducir_user(1).sql" PARA INTRODUCIR TODOS LOS VALORES Y DESPUÉS YA SE PUEDE CREAR LA FOREIGN KEY user_id DE LA TABLA transaction

ALTER TABLE transaction
ADD FOREIGN KEY(user_id) REFERENCES user(id);

# DA UN ERROR QUE INDICA QUE EN LA TABLA transaction HAY UN user_id QUE NO ESTÁ EN LA TABLA user. HAY QUE LOCALIZARLO 

SELECT DISTINCT transaction.user_id
FROM transaction 
LEFT JOIN user  
ON transaction.user_id = user.id
WHERE user.id IS NULL;

# CUANDO YA ESTÁ LOCALIZADO, LO CREAMOS EN LA TABLA user

INSERT INTO user (id)
VALUES ("9999");


# AHORA YA SE PUEDE CREAR LA FOREIGN KEY user_id DE LA TABLA transaction

ALTER TABLE transaction
ADD FOREIGN KEY(user_id) REFERENCES user(id);

#ALTER TABLE transaction
#DROP FOREIGN KEY transaction_ibfk_3;


# mirar las variables de las tablas. compararlas con el diagrama que tiene que resultar

# Cambios de las variables de la tabla COMPANY
ALTER TABLE company
DROP COLUMN website;

# Cambios de las variables de la tabla CREDIT_CARD
ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20);

ALTER TABLE credit_card
MODIFY COLUMN iban VARCHAR(50);

ALTER TABLE credit_card
MODIFY COLUMN cvv INT;

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(20);

ALTER TABLE credit_card
ADD fecha_actual DATE;

# Cambios de las variables de la tabla DATA_USER
ALTER TABLE user
RENAME COLUMN email to personal_email;

RENAME TABLE user TO data_user;

# Cambios de las variables de la tabla TRANSACTION
#No hay cambios


# Exercici 2
# L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
# ID de la transacció, Nom de l'usuari/ària, Cognom de l'usuari/ària, IBAN de la targeta de crèdit usada, Nom de la companyia de la transacció realitzada, 
# Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
# Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.

CREATE VIEW InformeTecnico AS
SELECT t.id AS IdTransaccion, du.name AS Nombre_Usuario, du.surname AS Apellido_Usuario, cc.iban AS IBAN, c.company_name AS Nombre_Compañia
FROM transaction t, data_user du, credit_card cc, company c
WHERE t.company_id = c.id AND t.user_id = du.id AND t.credit_card_id = cc.id;

SELECT * 
FROM InformeTecnico
ORDER BY IdTransaccion DESC;


#DROP VIEW InformeTecnico;

