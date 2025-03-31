--EDA in this project I will analyze the trends, Bank's Profits from different Customer and of different factors:


select *from bank_loan_data;

--Total Loan Application 
select count(id) as Total_Loan_Applications from bank_loan_data;

--Total Loan Applications for Month to Date. 
select count(id) as MTD_Total_Loan_Applications from bank_loan_data
where extract('month'from issue_date) = 12 and extract('year'from issue_date) = 2021;


--Percentage Rate of Loan Applications for a specific year.
select 
	month, year, 
	round(app_counts *100 / sum(app_counts) over(), 2) as Loan_Application_Percentage
from (
	select extract('month'from issue_date) as month, extract('year'from issue_date) as year, 
	count(id) as app_counts
	from bank_loan_data
	group by extract('month'from issue_date), extract('year'from issue_date)
	order by extract('month'from issue_date) asc
);


--Growth Rate over months of the Total Loan Application
select 
	to_char(issue_date, 'Mon') as Month, extract('year' from issue_date) as year, 
	count(id) as Present_Loan_applications, 
	lag(count(id), 1) over(order by extract('month' from issue_date)) as Previous_Loan_application, 
	round( (100.0*(count(id)-lag(count(id), 1) over(order by extract('month' from issue_date) asc))) / lag(count(id), 1) over(order by extract('month' from issue_date) asc) ,2) || '%' as Loan_application_growth_rate
from bank_loan_data 
group by to_char(issue_date, 'Mon'), extract('month' from issue_date), extract('year' from issue_date)
order by extract('month' from issue_date);


--Growth Rate over months of the Total Loan Application for a Specific State 
select 
	to_char(issue_date, 'Mon') as Month, extract('year' from issue_date) as year, 
	count(id) as Present_Loan_applications, 
	lag(count(id), 1) over(order by extract('month' from issue_date)) as Previous_Loan_application, 
	round( (100.0*(count(id)-lag(count(id), 1) over(order by extract('month' from issue_date) asc))) / lag(count(id), 1) over(order by extract('month' from issue_date) asc) ,2) || '%' as Loan_application_growth_rate
from bank_loan_data 
where address_state ilike 'ca'
group by to_char(issue_date, 'Mon'), extract('month' from issue_date), extract('year' from issue_date)
order by extract('month' from issue_date);



--Total Funded Amount
select sum(loan_amount) as Total_Funded_Amount from bank_loan_data;


--Total Funded Amount Month to date 
select sum(loan_amount) as MTD_Total_Funded_Amount from bank_loan_data
where extract('month'from issue_date) = 12 and extract('year'from issue_date) = 2021;


--Growth Rate of the Total Funded Amount.
select 
	to_char(issue_date, 'Mon') as Month, extract('year' from issue_date) as year, 
	sum(loan_amount) as Present_Funded_amount, 
	lag(sum(loan_amount), 1) over(order by extract('month' from issue_date)) as Previous_Funded_amount, 
	round( (100.0*(sum(loan_amount)-lag(sum(loan_amount), 1) over(order by extract('month' from issue_date) asc))) / lag(sum(loan_amount), 1) over(order by extract('month' from issue_date) asc) ,2) || '%' as Funded_Amount_growth_rate
from bank_loan_data 
group by to_char(issue_date, 'Mon'), extract('month' from issue_date), extract('year' from issue_date)
order by extract('month' from issue_date);


--Growth Rate of the Total Funded Amount.
select 
	to_char(issue_date, 'Mon') as Month, extract('year' from issue_date) as year, 
	sum(loan_amount) as Present_Funded_amount, 
	lag(sum(loan_amount), 1) over(order by extract('month' from issue_date)) as Previous_Funded_amount, 
	round( (100.0*(sum(loan_amount)-lag(sum(loan_amount), 1) over(order by extract('month' from issue_date) asc))) / lag(sum(loan_amount), 1) over(order by extract('month' from issue_date) asc) ,2) || '%' as Funded_Amount_growth_rate
from bank_loan_data 
where address_state ilike 'ca'
group by to_char(issue_date, 'Mon'), extract('month' from issue_date), extract('year' from issue_date)
order by extract('month' from issue_date);

--Total Amount Recieved. 
select sum(total_payment) as Total_Amount_Recieved from bank_loan_data;


--Total Amount Recieved for the last month.
select sum(total_payment) as MTD_Total_Amount_Recieved from bank_loan_data
where extract('month'from issue_date) = 12 and extract('year'from issue_date) = 2021;


--Growth Rate of the Amount Received.
select 
	to_char(issue_date, 'Mon') as Month, extract('year' from issue_date) as year, 
	sum(total_payment) as Present_amount_received,
	lag(sum(total_payment), 1) over(order by extract('month' from issue_date)) as Previous_amount_received,
	round( (100.0*(sum(total_payment)-lag(sum(total_payment), 1) over(order by extract('month' from issue_date) asc))) / lag(sum(total_payment), 1) over(order by extract('month' from issue_date) asc) ,2) || '%' as Amount_Received_growth_rate
from bank_loan_data 
group by to_char(issue_date, 'Mon'), extract('month' from issue_date), extract('year' from issue_date)
order by extract('month' from issue_date);


--Average Interest Rate 
select round(avg(int_rate), 4)* 100 as AVg_Interest_Rate from bank_loan_data;


--Average Interest Rate for the last month
select round(avg(int_rate), 4)* 100 as MTD_Avg_Interest_Rate from bank_loan_data
where extract('month'from issue_date) = 12 and extract('year'from issue_date) = 2021;

--Growth Rate of the Average Interest Rate.
select 
	to_char(issue_date, 'Mon') as Month, extract('year' from issue_date) as year, 
	round(avg(int_rate),4) as Present_Avg_int_rate,
	lag(round(avg(int_rate),4), 1) over(order by extract('month' from issue_date)) as Previous_Avg_int_rate,
	round( (100.0*(avg(int_rate)-lag(avg(int_rate), 1) over(order by extract('month' from issue_date) asc))) / lag(avg(int_rate), 1) over(order by extract('month' from issue_date) asc) ,2) || '%' as Avg_int_rate_growth_rate
from bank_loan_data 
group by to_char(issue_date, 'Mon'), extract('month' from issue_date), extract('year' from issue_date)
order by extract('month' from issue_date);


--Average DTI. 
select round(avg(dti), 4)* 100 as Avg_DTI from bank_loan_data;

--Average DTI for the last month.
select round(avg(dti), 4)* 100 as Avg_DTI from bank_loan_data
where extract('month'from issue_date) = 12 and extract('year'from issue_date) = 2021;

--Growth Rate of the Average DTI Rate.
select 
	to_char(issue_date, 'Mon') as Month, extract('year' from issue_date) as year, 
	round(avg(dti), 4) as Present_Avg_DTI_rate,
	lag(round(avg(dti), 4), 1) over(order by extract('month' from issue_date)) as Previous_Avg_DTI_rate,
	round( (100.0*(avg(dti)-lag(avg(dti), 1) over(order by extract('month' from issue_date) asc))) / lag(avg(dti), 1) over(order by extract('month' from issue_date) asc) ,2) || '%' as Avg_DTI_rate_growth_rate
from bank_loan_data 
group by to_char(issue_date, 'Mon'), extract('month' from issue_date), extract('year' from issue_date)
order by extract('month' from issue_date);


--Percentage of Good loan Application.

select 
	(count(case when loan_status ilike 'fully paid' or loan_status ilike 'current' then id end )*100.0)
	/
	count(id) as Good_Loan_Percentage
from bank_loan_data;


--Good Loan Applications
select 
	count(case when loan_status ilike 'fully paid' or loan_status ilike 'current' then id end) as Good_Loan_Application
from bank_loan_data;


--Total Funded amount for the good loans.
select 
sum(loan_amount) as Good_Loan_Fund_Amount
from bank_loan_data
where loan_status ilike 'fully paid' or loan_status ilike 'current';

--Total amount recieved from the good loans.
select 
sum(total_payment) as Good_Loan_Recieved_Amount
from bank_loan_data
where loan_status ilike 'fully paid' or loan_status ilike 'current';




--Percentage of Bad loan Application.

select 
	(count(case when loan_status ilike 'charged off' then id end)*100.0)
	/
	count(id) as Bad_Loan_Percentage
from bank_loan_data;

--Total Bad Loan Applications 
select 
	count(case when loan_status ilike 'charged off' then id end) as Bad_Loan_Applications
from bank_loan_data;


--Bad Loan Funded Loan Amount 
select 
sum(loan_amount) as Bad_Loan_Funded_Amount
from bank_loan_data
where loan_status ilike 'charged off';

--Bad Loan Received Amount.
select 
	sum(total_payment) as Bad_Loan_Recieved_Amount
from bank_loan_data
where loan_status ilike 'charged off';



--Loan Status.
select 
	loan_status, 
	count(id) as total_loan_application,
	sum(loan_amount) as funded_amount,
	sum(total_payment) as recieved_amount, 
	round(avg(int_rate *100),4) as average_int_rate, 
	round(avg(dti *100),4) as average_dti
from bank_loan_data 
group by loan_status;
	

--Loan Status for the last month.
select 
	loan_status, 
	count(id) as total_loan_application,
	sum(loan_amount) as funded_amount,
	sum(total_payment) as recieved_amount, 
	round(avg(int_rate *100),4) as average_int_rate, 
	round(avg(dti *100),4) as average_dti
from bank_loan_data 
where extract('month' from issue_date) = 12
group by loan_status;

----------------------------------------------------------------------------------------------------------------------------------------

--Monthly Trend


select 
	to_char(issue_date, 'Mon') as Month,
	count(id) as loan_applications,
	sum(loan_amount) as funded_amount, 
	sum(total_payment) as recieved_amount,
	round(avg(int_rate *100),4) as average_int_rate,
	round(avg(dti *100),4) as average_dti
from bank_loan_data
group by to_char(issue_date, 'Mon'), extract('month' from issue_date)
order by extract('month' from issue_date) asc;


--Trend by Region State.

select 
	address_state,
	count(id) as loan_applications,
	sum(loan_amount) as funded_amount, 
	sum(total_payment) as recieved_amount,
	round(avg(int_rate *100),4) as average_int_rate,
	round(avg(dti *100),4) as average_dti
from bank_loan_data
group by address_state
order by sum(loan_amount) desc;


--Trend by the Loan Term.
select 
	term,
	count(id) as loan_applications,
	sum(loan_amount) as funded_amount, 
	sum(total_payment) as recieved_amount,
	round(avg(int_rate *100),4) as average_int_rate,
	round(avg(dti *100),4) as average_dti
from bank_loan_data
group by term;


--Trend by employment length.
select 
	emp_length,
	count(id) as loan_applications,
	sum(loan_amount) as funded_amount, 
	sum(total_payment) as recieved_amount,
	round(avg(int_rate *100),4) as average_int_rate,
	round(avg(dti *100),4) as average_dti
from bank_loan_data
group by emp_length
order by emp_length;


--Loan Purpose Breakdown

select 
	purpose,
	count(id) as loan_applications,
	sum(loan_amount) as funded_amount, 
	sum(total_payment) as recieved_amount,
	round(avg(int_rate *100),4) as average_int_rate,
	round(avg(dti *100),4) as average_dti
from bank_loan_data
group by purpose
order by purpose;


--Trend by Home Ownership.
select 
	home_ownership,
	count(id) as loan_applications,
	sum(loan_amount) as funded_amount, 
	sum(total_payment) as recieved_amount,
	round(avg(int_rate *100),4) as average_int_rate,
	round(avg(dti *100),4) as average_dti
from bank_loan_data
group by home_ownership;



--Total Profit
select 
	sum(total_payment) - sum(loan_amount) as Total_Profit
from bank_loan_data;

--Good Loans Profit is making a good profit.
select 
	sum(total_payment) - sum(loan_amount) as Total_Profit
from bank_loan_data
where loan_status in ('Fully Paid', 'Current');


--Bad Loans Profit: is not making any profits.
select 
	sum(total_payment) - sum(loan_amount) as Total_Profit
from bank_loan_data
where loan_status ilike 'charged off';


--Monthly Profit 
select 
	 to_char(issue_date,'Mon') as month, extract('year' from issue_date) as year, 
	 sum(total_payment) - sum(loan_amount) as Profit
from bank_loan_data
group by extract('month' from issue_date), to_char(issue_date, 'Mon'),  extract('year' from issue_date)
order by extract('month' from issue_date);



--Monthly Profit Growth Rate.

select 
	to_char(issue_date,'Mon') as month, extract('year' from issue_date) as year,
	( sum(total_payment) - sum(loan_amount) ) as Current_profit, 
	lag( ( sum(total_payment) - sum(loan_amount) ), 1) over (order by extract('month' from issue_date) asc ) as Previous_Profit, 
	round( ( 100.0 * ( ( sum(total_payment) - sum(loan_amount) ) 
	- lag( ( sum(total_payment) - sum(loan_amount) ), 1 )over (order by extract('month' from issue_date) asc) ) )
	/ lag( ( sum(total_payment) - sum(loan_amount) ) , 1) over (order by extract('month' from issue_date) asc ) , 1)
from bank_loan_data
group by to_char(issue_date,'Mon'), extract('year' from issue_date), extract('month' from issue_date)
order by extract('month' from issue_date) asc;













	