--ulkesi spain france ya da germany olan musteriler kimler
select company_name, address, city, country
from customers
where country IN ('Spain', 'France', 'Germany');

--fax numarasini bilmedigim musteriler kimler?
select*
from customers
where fax IS NULL;


--Londrada ya da Pariste bulunan musteriler kimler?
select*
from customers
where city IN('London', 'Paris');

--Musterilerin arasinda en uzun isimli musteri kimdir?
select company_name, LENGTH(company_name) Len
from customers
ORDER BY len DESC
FETCH FIRST 1 ROW ONLY ;

--Hem Madrid`de ikamet eden hem de iletisim kisisi unvaninda 'owner' olan musteriler kimler?
select*
from customers
where city='Madrid' and contact_title='Owner';

--C ile baslayan kategori isimleri?

select category_name
from categories
where category_name LIKE 'C%';


--Adi 'A' harfi ile baslayan calisanlarin adi, soyadi, dogum taroho?
select FIRSTNAME, LASTNAME, BIRTHDATE
from employees
WHERE FIRSTNAME LIKE 'A%';


--1963 ve 1952 yilinda dogum gunu olan calisanlar kimler?
select*
from employees
WHERE EXTRACT(YEAR FROM TO_DATE(BIRTHDATE, 'DD/MM/YYYY')) IN (1963,1952);


--Bugun dogum gunu olan calisanlar kimler?
--Oncelikle tabloya bugun dogum gunu olan bir calisan verisi ekliyoruz
create sequence seq_emp
    MINVALUE 1
    MAXVALUE 99999999
    START WITH 111
    INCREMENT BY 1;
    
    
INSERT INTO employees(EMPLOYEE_ID,LASTNAME,FIRSTNAME,TITLE,TITLE_OF_COURTESY,BIRTHDATE,HIREDATE,ADDRESS,CITY,REGION,POSTAL_CODE,COUNTRY,HOME_PHONE,EXTENSION,PHOTO,NOTES,REPORTS_TO)
VALUES (seq_emp.nextval,'SAIKE','HATICE',null,null,to_date('20/12/1999', 'DD/MM/YYYY'),null,null,null,null,null,null,null,null,null,null,null);
--Ardinsan sorguyu yazabiliriz

select*
from employees
WHERE EXTRACT(MONTH FROM TO_DATE(BIRTHDATE, 'DD/MM/YYYY'))= EXTRACT(MONTH FROM SYSDATE) AND
EXTRACT(DAY FROM TO_DATE(BIRTHDATE, 'DD/MM/YYYY'))= EXTRACT(DAY FROM SYSDATE);

--ya da

select*
from employees
WHERE EXTRACT(MONTH FROM TO_DATE(BIRTHDATE))= EXTRACT(MONTH FROM SYSDATE) AND
EXTRACT(DAY FROM TO_DATE(BIRTHDATE))= EXTRACT(DAY FROM SYSDATE);


--Bu ay dogan calisanlar kimler?
SELECT*
FROM employees
WHERE TO_CHAR(BIRTHDATE, 'MM') = TO_CHAR(SYSDATE, 'MM');


--Isminde restaurant gecen musterilerin sirket adlari?
select company_name
from customers
where company_name LIKE '%Restaurant%';

--50$ ve 100$ arasinda freight(tasima ucreti)  olan tum siparislerin adlari ve fiyatlari
select freight,ship_name
from orders 
where  freight BETWEEN 50 AND 100;


--1 temmuz 1996 ve 31 aralik 1996 tarihleri arasindaki siparislerin id  ve tarihleri nelerdir?

select order_id,order_date
from orders
where order_date BETWEEN '01/07/1996' AND '31/07/1996';

--Tasima ucreti en pahali olan siparisin adi nedir?

select freight, ship_name
from orders
ORDER BY freight DESC
FETCH FIRST 1 ROW ONLY;

--ya da
select freight, ship_name
from orders
where freight= (select max(freight) from orders);


--en ucuz bes siparisi getir?
select rownum, x.*
from(
select freight
from orders
order by freight)x
where rownum<6;


--en ucuz bes siparisin ortalama fiyati?
select AVG(freight) totalFreight
from(
select freight
from orders
ORDER BY freight
FETCH FIRST 5 ROW ONLY);

--Customerde contact_name`lerin hepsine on ek olarak 'PR' ekle ve buyuk harf olarak ekrana yazdir?
select 'PR ' || UPPER(contact_name)
from customers;

--ya da
SELECT CONCAT('PR ', UPPER(contact_name)) 
FROM customers;

--1997 subat ayinda kac siparisim var?
select COUNT(*)
from orders
where  TO_CHAR(ORDER_DATE, 'MM')=02 
AND TO_CHAR(ORDER_DATE, 'YYYY')=1997;

--1997 yilinda siparis veren musterilerimin contactname ve telefon numaralari neler? 
select DISTINCT c.contact_name, c.phone
from orders o
INNER JOIN customers c on c.customer_id=o.customer_id
where TO_CHAR(o.ORDER_DATE, 'YYYY')=1997;


--Tasima ucreti 40 uzeri olan siparislerin sehri, musterinin adi?
select DISTINCT c.city, c.contact_name
from orders o
INNER JOIN customers c ON c.customer_id= o.customer_id
where o.freight>40;

--Geciken siparisler?

select*
from orders
where shipped_date>required_date;

--Geciken siparislerin tarihi, musterisinin adi nedir?
select o.order_date, c.contact_name
from orders o
INNER JOIN Customers c ON c.customer_id=o.customer_id
where o.shipped_date>o.required_date;


--Siparis alan personelin adi, soyadi, siparis tarihi, siparis id(siralama siparis tarihine gore)

select e.firstname, e.lastname,o.order_date, o.order_id
from orders o
INNER JOIN employees e ON e.employee_id=o.employee_id 
ORDER BY o.order_date; 

--Son bes siparisin ortalama fiyati ve Orderid`leri?(sepet toplami ortalamasu)
select o.order_id, o.order_date, od.quantity, od.unit_price
from orders o
INNER JOIN "Order Details" od ON od.order_id = o.order_id
where o.order_id IN (
    select order_id from orders ORDER BY order_date DESC FETCH FIRST 5 ROWS ONLY
);

