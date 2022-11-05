 CREATE VIEW Analytics_main AS
SELECT  s.set_num,s.name AS set_name,s.year,s.theme_id,s.num_parts,t.name AS theme_name,t.parent_id,p.name AS parent_theme_name
FROM sets AS s
	LEFT JOIN themes AS t
	ON s.theme_id=t.id
	LEFT JOIN themes AS p
	ON t.parent_id=p.id
SELECT * FROM Analytics_main

 -- 1 --
-- what is the total no of parts per theme
SELECT theme_name,SUM(num_parts) AS Total_num_parts
FROM Analytics_main
-- WHERE parent_theme_name IS NOT NULL
GROUP BY theme_name
ORDER BY SUM(num_parts) DESC


-- 2 --
-- What is the total no of parts per year
SELECT year,SUM(num_parts) AS Total_num_parts
FROM Analytics_main
-- WHERE parent_theme_name IS NOT NULL
GROUP BY year
ORDER BY SUM(num_parts) DESC


-- 3--
-- How many sets were created in each century in the dataset 
SELECT Century,COUNT(set_num) AS Total_Num_Sets
FROM Analytics_main
-- WHERE parent_theme_name IS NOT NULL
GROUP BY Century


-- 4--
-- what percentage of sets ever released in 21st were Train Themed
WITH CTE AS
(SELECT Century,theme_name,count(set_num) AS Total_num_set
FROM Analytics_main
WHERE Century ="21st Century"
GROUP BY Century,theme_name)
SELECT SUM(Total_num_set),SUM(Percentage)
FROM(
SELECT Century,theme_name,Total_num_set,SUM(Total_num_set) OVER() AS Sum_Total,
	ROUND(Total_num_set/SUM(Total_num_set) OVER() *100,3) AS Percentage
FROM CTE
) M
WHERE theme_name LIKE "%Train%"
ORDER BY Total_num_set DESC


-- 5--
-- what was popular theme by year in terms of sets released in the 21st century
SELECT year,theme_name,Total_num_set
FROM(
	SELECT year,theme_name,count(set_num) AS Total_num_set,ROW_NUMBER() OVER(PARTITION BY year ORDER BY count(set_num) DESC) RN
	FROM Analytics_main
	WHERE Century ="21st Century"
	GROUP BY year,theme_name
    )M
WHERE RN = 1
ORDER BY year DESC


-- 6 --
-- what is the most produced color of lego ever in terms of quantity of parts
CREATE VIEW Color_analytics	AS 
SELECT inv.color_id,inv.inventory_id,inv.part_num,inv.quantity,c.name AS color_name,c.rgb,p.name AS part_name,p.part_material,pc.name AS category_name
	FROM inventory_parts AS inv
	INNER JOIN colors AS c
	ON inv.color_id = c.id
	INNER JOIN parts AS p
	ON inv.part_num = p.part_num
	INNER JOIN part_categories AS pc
	ON p.part_cat_id = pc.id
SELECT color_name,SUM(quantity) AS Quantity_of_parts
FROM Color_analytics
GROUP BY color_name
ORDER BY SUM(quantity) DESC





















