#Escribe una consulta para obtener los 5 clientes con mayor monto total de ventas en los últimos 6 meses. (5 puntos) 
SELECT
	c.id,
	CONCAT(c.nombre, ' ', c.apellido) AS cliente,
	SUM(v.monto) AS monto_total
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE v.fecha >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.id, cliente	
ORDER BY monto_total DESC
LIMIT 5;

#Escribe una consulta para calcular el ticket promedio de ventas por cliente en el último año. (5 puntos) 
SELECT 
	c.id, 
	CONCAT(c.nombre, ' ', c.apellido) AS cliente, 
	ROUND(AVG(v.monto), 0) AS ticket_promedio
FROM clientes c 
JOIN ventas v ON c.id = v.cliente_id
WHERE v.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id, cliente;

#Escribe una consulta para obtener el nombre completo de los clientes y su monto total de
#ventas. (10 puntos)
SELECT
	c.id,
	CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    SUM(v.monto) AS monto_total
FROM clientes c 
JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id, cliente
ORDER BY monto_total DESC;

#Escribe una consulta para obtener el ingreso promedio de ventas por mes. (10 puntos)
SELECT
	DATE_FORMAT(fecha, '%Y-%m') AS mes,
    ROUND(AVG(monto), 0) AS promedio_ventas
FROM ventas
GROUP BY mes
ORDER BY mes;

#Escribe una consulta para calcular el ranking de clientes por ventas en el último año.
SELECT 
	c.id, 
	CONCAT(c.nombre, ' ', c.apellido) AS cliente, 
	SUM(v.monto) AS total_ventas,
	RANK() OVER (ORDER BY SUM(v.monto) DESC) AS ranking
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
WHERE v.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id, cliente
ORDER BY ranking;

#Escribe una consulta para calcular el total de ventas por cliente y luego selecciona solo los
#clientes cuyo total de ventas es superior al promedio general. (10 puntos)

WITH TotalVentasPorCliente AS (
	SELECT 
		cliente_id,
        COUNT(id) AS total_ventas
	FROM ventas
    GROUP BY cliente_id
), 
PromedioGeneral AS (
	SELECT ROUND(AVG(total_ventas), 0) AS promedio
    FROM TotalVentasPorCliente
)
SELECT t.cliente_id, t.total_ventas
FROM TotalVentasPorCliente t
JOIN PromedioGeneral p  ON t.total_ventas > p.promedio;