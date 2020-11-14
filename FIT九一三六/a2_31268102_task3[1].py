# Header
# Student name: Shihan Zhang
# Student ID: 31268102
# start date: 2020-05-26
# last modified date:  2020-06-07
# Simulation order : ordered as the reading from the text file
#                    from the first person to last person
################################################################

# Simulation case 1 (30, 0.60, 25) -> scenario A: an uncontained outbreak
# Prediction: out of control
# actual result: out of control
# Explain: The value entered by the user is greater than the random number'will_meet' in task2.
#          Caused a lot of social activities, the virus spread very quickly.
#          contagious has grown exponentially, the situation has quickly out of control.
#          Start on the 25th day. Basically everyone has been infected.

# Simulation case 2 (60, 0.25, 49) -> scenario B: an unpredictable situation
# Prediction: unpredictable
# actual result: linear increase then huge increase
# Explain: Although there are social restrictions, but social activities have not stopped.
#          The virus is spreading slowly but still causes a lot of infections.
#          The number of contagious increased linearly with fluctuations within first 30 days.
#          after day 40, contagious has grown exponentially, the situation has quickly out of control.
#          compare the trend of 'day 1-30' and 'day 40-60'. the significant increases
#          makes trend become unpredictable.

# Simulation case 2 (90, 0.18, 40) -> scenario C: flattening the curve
# Prediction: safe
# actual result: Very few infections
# Explain: Social distance successfully prevented the spread of the virus,
#          and after a very small number of infections,
#          the community's health status was stable. There was no recurrence.

from a2_31268102_task2 import *
import matplotlib.pyplot as plot


def visual_curve(days, meeting_probability, patient_zero_health):
    # run simulation with the passing value
    # 'run_simulation()' imported from task2
    each_day_num = run_simulation(days, meeting_probability, patient_zero_health)
    # print simulation result
    print(each_day_num)
    # figure size
    fig = plot.figure(figsize=(6, 4))
    fig.tight_layout()
    # set value for x-axis
    x = [item for item in range(days)]
    # draw the plot with x and y
    plot.plot(x, each_day_num)
    # draw x-axis and font
    plot.xlabel("Days", fontproperties="SimHei")
    # draw y-axis and font
    plot.ylabel("Count", fontproperties="SimHei")
    # plot title
    plot.title("Simulation", fontproperties="SimHei")
    # # save pic to local
    # plot.savefig("./simulation1.png", dpi=200, bbox_inches='tight')
    # # pop up the showing window
    # plot.show()
    return plot


if __name__ == '__main__':
    # 3 test cases
    # 30, 0.60, 25
    # 60, 0.25, 49
    # 90, 0.18, 40

    # init run counts, also using for naming output pic
    n = 0
    # run 3 test case
    while True and n < 3:
        # user input for days
        days = input('enter the total days for simulation： ')
        # convert to int
        days = int(days)
        # user input for probability
        the_meeting_probability = input('enter meeting probability：')
        # convert to float
        the_meeting_probability = float(the_meeting_probability)
        # user enter patient zero HP
        patient_zero_health = input('enter health point of patient zero： ')
        # convert to float
        patient_zero_health = float(patient_zero_health)
        # print input
        # print("days: ", days, "probability: ", the_meeting_probability,
         #     "patient zero health point: ", patient_zero_health)
        # call plot function to draw plots
        plot = visual_curve(days, the_meeting_probability, patient_zero_health)
        picName = f'./simulation{n+1}.png'
        plot.savefig(picName, dpi=200, bbox_inches='tight')
        n += 1
