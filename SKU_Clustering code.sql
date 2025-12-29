--
select
	sku,
	ROUND(AVG(
		case
			when 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0)<0 then 0
			else 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0)
		end),2) as fcst_accy,
	AVG(actual_demand) as avg_demand,
	ROUND(STDEV(actual_demand),0) as stdev_demand,
	SUM(actual_demand) as total_demand,
	ROUND(STDEV(actual_demand)/AVG(actual_demand),2) as CV,
	case
		when ROUND(STDEV(actual_demand)/NULLIF(AVG(actual_demand),0),2)<=0.2 
		     and ROUND(AVG(case when 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0)<0 then 0
		                        else 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0) end),2)<=0.8 
		     then 'Priority 1'
		when ROUND(STDEV(actual_demand)/NULLIF(AVG(actual_demand),0),2) between 0.21 and 0.3 
		     and ROUND(AVG(case when 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0)<0 then 0
		                        else 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0) end),2)<=0.8 
		     then 'Priority 2'
		when ROUND(STDEV(actual_demand)/NULLIF(AVG(actual_demand),0),2) between 0.31 and 0.5 
		     and ROUND(AVG(case when 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0)<0 then 0
		                        else 1-ABS(forecast-actual_demand)*1.0/NULLIF(actual_demand,0) end),2)<=0.8 
		     then 'Priority 3'
		else ''
	end as Flag
from
	dbo.sku_clustering 
group by
	sku

