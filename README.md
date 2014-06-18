Creating Dummy Operational Data
===============================

For the purposes of an exercise, I created *dummy* data, that is, **fake** data for the following variables: 

- **OH010**	Number of People in Need
- **OH020**	Number of People Targeted for Assistance
- **OH030**	Number of People Reached
- **OH040**	Number of IDPs
- **OH050**	Number of People in Camps
- **OH060**	Number of Refugees
- **OH070**	Number of Returnees
- **OH080**	Number of People Affected
- **OH090**	Share of People Affected to the Total Population

The seed for all the data is the indicator **OH080**	*Number of People Affected*. To make that indicator interestingly accurate, I used the following four variables: 

  - World Bank's Income Level classification as a categorical variable.
  - Number of Reports on ReliefWeb (normalized) as the predictor.
  - OCHA field operation status as a categorical variable.
  - The total population of the country as provided by UNDESA (through the WDI tables) as the base population.

Which are used in the following equation (don't mind the notation):

![number of people affected equation](https://raw.githubusercontent.com/luiscape/dummy_operational_data/master/formula.gif)

In short, the equation calculates the *Number of People Affected* to every one of OCHA's field operations (24 in total). It uses the income level to estimate roughly how many people could had been affected and the normalized number of reports on ReliefWeb as a predictor that actually determinates the number of people affected. Basically, if there are more reports on ReliefWeb on that year about a certain country, more were affected by a humanitarian crisis.

Results
-------

The two plots below illustrate the results. 

**People Affected in Haiti**
Here we see that the situation in Haiti was gradually getting more severe, which matches the increased participation of UN peacekeepers. Reaching its peak in 2010 with the earthquake.
![population affected in Haiti](https://raw.githubusercontent.com/luiscape/dummy_operational_data/master/hti.png)

**People Affected in Yemen**
Or Yemen that has seen a surge of people affected reaching the maximum of 25% of the total population affected.
![population affected in Haiti](https://raw.githubusercontent.com/luiscape/dummy_operational_data/master/yem.png)


**People Affected in Afghanistan**
Here we see that at the beginning of the NATO-led operation, the share of the population "affected" by the crisis reached 100%. It then decreased gradually to around 40%, the current rate.
![population affected in Afghanistan](https://raw.githubusercontent.com/luiscape/dummy_operational_data/master/afg.png)
