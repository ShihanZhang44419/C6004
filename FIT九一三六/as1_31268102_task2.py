import math

# initialise the Number of simulations.
NUM_OF_SIM = 3
# initialise the crisis happen frequency
CRIS_RECUR_FREQUENCY = 9
#
PER_DEF = 5


def read_data():
    f = open("AU_INV_START.txt", "r")
    data_dict = {"start_year": int(f.readline()),
                 "start_stock": int(f.readline()),
                 "start_revenue": int(f.readline())}
    f.close()
    return data_dict

def cal_stock_revenue(data_dict):
    # get date value and convert to string
    date_value = str(data_dict['start_year'])
    # split the date value to yyyy, mmdd
    date_list = [date_value[i:i + 4] for i in range(0, len(date_value), 4)]
    # split the date value to yy, yy, mm, dd
    month_day_list = [date_value[i:i + 2] for i in range(0, len(date_value), 2)]
    # initialise the days value for leap year
    leap_year_month = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    # initialise the days value for normal year
    normal_year_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    # initialise the input year
    input_year = int(date_list[0])
    # initialise the input month
    input_month = int(month_day_list[2])
    # initialise the input day
    input_day = int(month_day_list[3])
    # initialise defective rate
    def_rate = PER_DEF / 100
    # define the default month, date value can not be 0
    if input_month > 0:
        default_month = input_month
    else:
        default_month = 1

    # define the default days, date value can not be 0
    if input_day > 0:
        default_day = input_day
    else:
        default_day = 1

    # initialise the normal RRP and Peak RRP
    init_price = peak_price = 705

    # initialise the normal sale amount and Peak sale amount to distributor
    init_sales = peak_sales = 36

    # initialise the stock value
    init_stock = data_dict['start_stock']

    # initialise the default year, while loop run from 0, so the default year should be 2000 - 1 = 1999
    default_year = 1999

    # initialise the time of year will be runs
    run_year = 0

    # initialise the gap between the input year and default year
    year_gap = input_year - default_year

    # initialise the end year, the end year is the last year of runs
    end_year = NUM_OF_SIM + year_gap - 1

    # initialise the crisis year
    crisis_first = 0
    crisis_second = 0
    crisis_third = 0
    crisis_base = 0

    # initialise the list of defective revenue (monthly)
    defective_revenue_list = [0]

    # initialise the list of monthly revenue
    monthly_revenue_list = [0]

    # initialise the list of defective return monthly
    defective_return_list = [0]

    # cut profit list
    cut_profit_list = [0]

    # initialise the initial revenue
    init_revenue = data_dict['start_revenue']

    # initialise the defective revenue & monthly revenue & defective sales amount
    defective_revenue = cut_profit = defective_sales = 0

    # while loop for running the years of simulation
    while run_year < end_year:
        default_year += 1
        run_year += 1

        # initialise the month value
        month = 0

        # if input month greater is than 1, cut the head month
        # if run_year == 1:
        #     month = default_month - 1

        # get the leap year and set the days value for month
        if default_year % 4 == 0:
            # set month list to leap year month (29th Feb)
            set_month = leap_year_month
        else:
            # set month list to leap year month (28th Feb)
            set_month = normal_year_month

        # get crisis happen year, if current year % 12 = 0, the crisis happens
        if ((run_year + 2) % (CRIS_RECUR_FREQUENCY + 3)) == 0:
            # set first crisis year
            crisis_first = default_year
            # set second crisis year
            crisis_second = default_year + 1
            # set third crisis year
            crisis_third = default_year + 2
            crisis_base += 1

        # set crisis boolean, crisis condition
        if default_year == crisis_first or default_year == crisis_second or default_year == crisis_third:
            crisis = True
        else:
            crisis = False

        # set number of runs for bugging
        num_of_runs = 0

        # cut tails month
        # set month_list_length which is 12
        month_list_length = len(leap_year_month)

        # if is end year and then length = default month
        if run_year == end_year:
            month_list_length = default_month
        # while loop that run 12 time when is not end year, when reach end year run == default month time
        # eg 2000 0101 to 20020101, when year is 2002 then month only runs to 1.
        while month < month_list_length:
            month += 1
            # initialise days counter
            d_counter = 0

            # when cutting the month on certain year, the day value is not synchronized with the month
            # initialise the synchronize variable
            sync_month = 0
            # sync days with month by loop
            while sync_month < month:
                sync_month += 1
            # set days value, eg: when sync is 5, index (5 - 1) of set_mont is 4th vale which is May and has 31 days.
            has_days = set_month[(sync_month - 1)]

            # cut head of days, if input is 2000 05 05. then days start form 5th
            if month == default_month and run_year == 1:
                d_counter = default_day - 1

            # cut tail of days, cut head of days, if input is 2000 05 05. then days ends on 5th
            if month == default_month and run_year == end_year:
                has_days = default_day
            # set increased price and sale amount for every following financial year
            if run_year >= 1 and month >= 7:
                # the inflation rate formula is Peak price * 1.05^n + 1, n is the year to runs, +1 because 2000 has
                # the first new financial year.
                init_price = (peak_price * (1.05 ** run_year))
                # the inflation rate formula is Peak price * 1.1^n + 1,
                init_sales = (peak_sales * (1.1 ** run_year))
            else:
                init_price = (peak_price * (1.05 ** (run_year - 1)))
                # the inflation rate formula is Peak price * 1.1^n + 1,
                init_sales = (peak_sales * (1.1 ** (run_year - 1)))

            # loop for running days. loop ends when
            while d_counter < has_days:
                d_counter += 1
                # sum up num of runs
                num_of_runs = num_of_runs + 1
                # set price value and sales amount on peak period, when Jan and Feb.
                if month == 1 or month == 2:
                    # if crisis is True, price and sales amount is changed
                    if crisis:
                        if default_year == crisis_first:
                            # set first year price increases 10%
                            day_price = round((init_price * (1.1 ** crisis_base)), 2)
                            # first year sales drop 20%
                            day_sales = math.ceil((init_sales * (0.8 ** crisis_base)))
                        elif default_year == crisis_second:
                            # second year price increases 5%
                            day_price = round((init_price * (1.155 ** crisis_base)), 2)
                            # second year sale drop 10%
                            day_sales = math.ceil((init_sales * (0.72 ** crisis_base)))
                        else:
                            # third year price increases 3%
                            day_price = round((init_price * (1.18965 ** crisis_base)), 2)
                            # third year sales amount drop 5%
                            day_sales = math.ceil((init_sales * (0.684 ** crisis_base)))
                    # if crisis not happens
                    else:
                        if default_year > 2019:
                            day_price = round((init_price * (1.18965 ** crisis_base)), 2)
                            day_sales = math.ceil(init_sales * (0.684 ** crisis_base))
                        else:
                            day_price = round(init_price, 2)
                            day_sales = math.ceil(init_sales)
                    # set defective price changes
                    # no price for initial year January
                    if run_year == 1 and month == 1:
                        defective_price = 0
                    # set defective price, defective price is 80% of current month
                    else:
                        defective_price = round((day_price * 0.8), 2)
                    # set monthly total sales amount:
                    monthly_out = day_sales * d_counter
                    # set monthly returned defectives
                    defective_sales = math.ceil(monthly_out * def_rate)
                    # calculate stock decreases for daily
                    init_stock = init_stock - day_sales
                    # calculate daily revenue
                    day_revenue = day_price * day_sales
                    # calculate the revenue changed as the monthly revenue will out put from higher loop
                    init_revenue = round((init_revenue + day_revenue), 2)

                    # refill stock when current stock lower than 400
                    if init_stock <= 400:
                        init_stock = init_stock + 600

                    # The initial stock changes relate to defective
                    # initial year after January, only add once which on 1st day of the month, so day counter = 1
                    if run_year == 1 and month > 1 and d_counter == 1:
                        # add defective to initial stock
                        init_stock = init_stock + int(defective_return_list[month - 1])
                        # calculate the defective's revenue
                        defective_revenue = round((defective_price * int(defective_return_list[month - 1])), 2)
                    # after initials year and the month is January
                    elif run_year > 1 and month == 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[(run_year - 1) * 12])
                        defective_revenue = round(
                            (defective_price * int(defective_return_list[(run_year - 1) * 12])), 2)
                    # after initials year and the month after January
                    elif run_year > 1 and month > 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[(run_year - 1) * 12 + month - 1])
                        defective_revenue = round(
                            (defective_price * int(defective_return_list[(run_year - 1) * 12 + month - 1])), 2)

                    # cut off profit
                    if run_year == 1 and month == 1:
                        cut_profit = 0
                    elif run_year == 1 and month > 1:
                        cut_profit = round((int(defective_return_list[month - 1]) * day_price), 2)
                    elif run_year > 1:
                        cut_profit = round(
                            (int(defective_return_list[(run_year - 1) * 12 + month - 1]) * day_price), 2)
                # set price value and sales amount on normal period, when March to June.
                elif month == 3 or month == 4 or month == 5 or month == 6:
                    # the price factor for calculate normal period price
                    price_factor = 1.2
                    sales_factor = 1.35
                    # if crisis is True, price and sales amount is changed
                    if crisis:
                        if default_year == crisis_first:
                            # set first year price increases 10%
                            day_price = round(((init_price / price_factor) * (1.1 ** crisis_base)), 2)
                            # first year sales drop 20%
                            day_sales = math.ceil((init_sales / sales_factor) * (0.8 ** crisis_base))
                        elif default_year == crisis_second:
                            # second year price increases 5%
                            day_price = round(((init_price / price_factor) * (1.155 ** crisis_base)), 2)
                            # second year sale drop 10%
                            day_sales = math.ceil((init_sales / sales_factor) * (0.72 ** crisis_base))
                        else:
                            # third year price increases 3%
                            day_price = round(((init_price / price_factor) * (1.18965 ** crisis_base)), 2)
                            # third year sales amount drop 5%
                            day_sales = math.ceil((init_sales / sales_factor) * (0.684 ** crisis_base))
                    else:
                        if default_year > 2019:
                            day_price = round(((init_price / price_factor) * (1.18965 ** crisis_base)), 2)
                            day_sales = math.ceil((init_sales / sales_factor) * (0.684 ** crisis_base))
                        else:
                            day_price = round(init_price / price_factor, 2)
                            day_sales = math.ceil(init_sales / sales_factor)
                    # price and stock calculation
                    # set defective price
                    if month < 4:
                        defective_price = round((init_price * 0.8), 2)
                    else:
                        defective_price = round((day_price * 0.8), 2)

                    monthly_out = day_sales * d_counter
                    defective_sales = math.ceil(monthly_out * def_rate)
                    day_revenue = day_price * day_sales
                    init_stock = int(init_stock - day_sales)
                    init_revenue = round((init_revenue + day_revenue), 2)
                    # refill stock
                    if init_stock <= 400:
                        init_stock = init_stock + 600

                    # The initial stock changes relate to defective
                    # first year month after January
                    if run_year == 1 and month > 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[month - 1])
                        defective_revenue = round((defective_price * int(defective_return_list[month - 1])), 2)
                    # after first year and after January
                    elif run_year > 1 and month > 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[(run_year - 1) * 12 + (month - 1)])
                        defective_revenue = round(
                            (defective_price * int(defective_return_list[(run_year - 1) * 12 + (month - 1)])), 2)

                    # cut off profit
                    if run_year == 1 and month > 1:
                        cut_profit = round((int(defective_return_list[month - 1]) * day_price), 2)
                    elif run_year > 1:
                        cut_profit = round(
                            (int(defective_return_list[(run_year - 1) * 12 + month - 1]) * day_price), 2)

                # set price value and sales amount on financial period, when March to June.
                elif month == 7 or month == 8 or month == 9 or month == 10:
                    # set price factor and sales amount factor.
                    price_factor = 1.2
                    sales_factor = 1.35
                    # if crisis is True, price and sales amount is changed
                    if crisis:
                        if default_year == crisis_first:
                            # set first year price increases 10%
                            day_price = round(((init_price / price_factor) * (1.1 ** crisis_base)), 2)
                            # first year sales drop 20%
                            init_price = math.ceil((init_sales / sales_factor) * (0.8 ** crisis_base))
                        elif default_year == crisis_second:
                            # second year price increases 5%
                            init_price = round(((init_price / price_factor) * (1.155 ** crisis_base)), 2)
                            # second year sale drop 10%
                            day_sales = math.ceil((init_sales / sales_factor) * (0.72 ** crisis_base))
                        else:
                            # third year price increases 3%
                            init_price = round(((init_price / price_factor) * (1.18965 ** crisis_base)), 2)
                            # third year sales amount drop 5%
                            day_sales = math.ceil((init_sales / sales_factor) * (0.684 ** crisis_base))
                    else:
                        if default_year > 2019:
                            day_price = round(((init_price / price_factor) * (1.18965 ** crisis_base)), 2)
                            day_sales = math.ceil((init_sales / sales_factor) * (0.684 ** crisis_base))
                        else:
                            day_price = round(init_price / price_factor, 2)
                            day_sales = math.ceil(init_sales / sales_factor)
                    # price and stock calculation
                    # set defective price
                    if month < 8:
                        defective_price = round(((init_price / 1.2) * 0.8), 2)
                    else:
                        defective_price = round((day_price * 0.8), 2)

                    monthly_out = day_sales * d_counter
                    defective_sales = math.ceil(monthly_out * def_rate)
                    day_revenue = day_price * day_sales
                    init_stock = int(init_stock - day_sales)
                    init_revenue = round((init_revenue + day_revenue), 2)
                    # refill stock
                    if init_stock <= 400:
                        init_stock = init_stock + 600

                    # add defective stock to next month
                    # initial year after January
                    if run_year == 1 and month > 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[month - 1])
                        defective_revenue = round((defective_price * int(defective_return_list[month - 1])), 2)
                    # next year after January
                    elif run_year > 1 and month > 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[(run_year - 1) * 12 + (month - 1)])
                        defective_revenue = round(
                            (defective_price * int(defective_return_list[(run_year - 1) * 12 + (month - 1)])), 2)
                    # cut off profit
                    if run_year == 1 and month > 1:
                        cut_profit = round((int(defective_return_list[month - 1]) * day_price), 2)
                    elif run_year > 1:
                        cut_profit = round(
                            (int(defective_return_list[(run_year - 1) * 12 + month - 1]) * day_price), 2)

                # set price value and sales amount on financial period, when November to December.
                else:
                    # set price and sale factor
                    if crisis:
                        if default_year == crisis_first:
                            # set first year price increases 10%
                            day_price = round((init_price * (1.1 ** crisis_base)), 2)
                            # first year sales drop 20%
                            day_sales = math.ceil((init_sales * (0.8 ** crisis_base)))
                        elif default_year == crisis_second:
                            # second year price increases 5%
                            day_price = round((init_price * (1.155 ** crisis_base)), 2)
                            # second year sale drop 10%
                            day_sales = math.ceil((init_sales * (0.72 ** crisis_base)))
                        else:
                            # third year price increases 3%
                            day_price = round((init_price * (1.18965 ** crisis_base)), 2)
                            # third year sales amount drop 5%
                            day_sales = math.ceil((init_sales * (0.684 ** crisis_base)))
                    else:
                        if default_year > 2019:
                            day_price = round((init_price * (1.18965 ** crisis_base)), 2)
                            day_sales = math.ceil(init_sales * (0.684 ** crisis_base))

                        else:
                            day_price = round(init_price, 2)
                            day_sales = math.ceil(init_sales)

                    # price and stock calculation
                    # set defective price
                    if month < 12:
                        defective_price = round(((init_price / 1.26) * 0.8), 2)
                    else:
                        defective_price = round((day_price * 0.8), 2)

                    monthly_out = day_sales * d_counter
                    defective_sales = math.ceil(monthly_out * def_rate)
                    day_revenue = day_price * day_sales
                    init_stock = init_stock - day_sales
                    init_revenue = round((init_revenue + day_revenue), 2)
                    end_year_stock = init_stock
                    end_year_revenue = init_revenue
                    # refill stock
                    if init_stock <= 400:
                        init_stock = init_stock + 600

                    # add defective stock to next month
                    # first year after January
                    if run_year == 1 and month > 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[month - 1])
                        defective_revenue = round((defective_price * int(defective_return_list[month - 1])), 2)

                    # next year after January
                    elif run_year > 1 and month > 1 and d_counter == 1:
                        init_stock = init_stock + int(defective_return_list[(run_year - 1) * 12 + (month - 1)])
                        defective_revenue = round(
                            (defective_price * int(defective_return_list[(run_year - 1) * 12 + (month - 1)])), 2)

                    # cut off profit
                    if run_year == 1 and month > 1:
                        cut_profit = round((int(defective_return_list[month - 1]) * day_price), 2)
                    elif run_year > 1:
                        cut_profit = round(
                            (int(defective_return_list[(run_year - 1) * 12 + month - 1]) * day_price), 2)

                # # break the loop if sales amount greater than 1000

                # print for checking & debugging
                print(run_year, crisis, default_year, month, d_counter, day_sales, day_price, defective_price,
                      init_stock, defective_sales, init_revenue, defective_revenue)
                # # print(run_year, crisis, default_year, month, d_counter, day_sales, day_price, cut_profit, defective_price, defective_sales, defective_revenue)
            # append returned amount to list
            defective_return_list.append(defective_sales)
            # append monthly revenue to list
            monthly_revenue_list.append(init_revenue)
            # append defective's revenue monthly to list
            defective_revenue_list.append(defective_revenue)
            # append cut profit to list
            cut_profit_list.append(cut_profit)
    # remove the 0 from the list
    monthly_revenue_list.remove(0)
    defective_return_list.remove(0)
    defective_revenue_list.remove(0)
    cut_profit_list.remove(0)
    # print(monthly_revenue_list)
    # print(defective_revenue_list)
    # print(cut_profit_list)
    # calculate total revenue

    for sum_round in range(len(monthly_revenue_list)):
        total_revenue = round((monthly_revenue_list[sum_round - 1] - cut_profit_list[sum_round - 1] +
                               defective_revenue_list[sum_round - 1]), 2)
        # total_revenue += total_revenue
        # print(total_revenue)

    # print(total_revenue)
    # format the day and month value
    if input_day < 10 and input_month < 10:
        input_month = "0" + str(input_month)
        input_day = "0" + str(input_day)
    year_value = str(default_year) + str(input_month) + str(input_day)
    # add data to dictionary
    final_info = {"end_year": year_value,
                  "end_stock": str(init_stock),
                  "end_revenue": str(total_revenue)}
    return final_info


def write_data(final_info):
    print(final_info)
    # write to file
    f = open("AU_INV_END.txt", "w")
    final_data = str(final_info["end_year"]) + "\n" + str(final_info["end_stock"]) + "\n" + str(final_info["end_revenue"])
    f.write(final_data)
    f.close()


cal_stock_revenue(read_data())
#write_data(cal_stock_revenue(read_data()))
