# coding: utf8
import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import seaborn as sns


engine = create_engine('mysql+pymysql://rafik:simplon@localhost/startups50')


def graphique():

    #data = pd.read_sql_query('select * from startups50', engine)

    data = pd.read_csv("app/static/50_Startups.csv", thousands=',')
    col_new = ['startup_id', 'RDSpend', 'Administration', 'MarketingSpend', 'State', 'Profit']
    col_old = data.columns
    for i in range(len(col_old)) :
        data = data.rename(columns={col_old[i]: col_new[i+1]})

    palette=sns.color_palette("Paired")
    sns.set_palette(palette)

    plt.figure(figsize=[15,20])
    plt.gcf().subplots_adjust(wspace = 0.5, hspace = 0.5)
    
    plt.subplot(321)
    sns.countplot(data= data, x="State")
    plt.title("Disciplines des médaillés d'or de plus de 45 ans")
    plt.xticks(rotation=45)
    plt.xlabel('Etat')

    plt.subplot(323)
    sns.distplot(data["Profit"])
    plt.title("Distribution du profit des startups")
    plt.xticks(rotation=45)
    plt.xlim(0, 300000)
    plt.xlabel('Profit $')

    plt.subplot(324)
    sns.distplot(data["Administration"])
    plt.title("Distribution des dépenses administratives")
    plt.xticks(rotation=45)
    plt.xlim(0, 300000)
    plt.xlabel('Dépense $')

    plt.subplot(325)
    sns.distplot(data["MarketingSpend"])
    plt.title("Distribution des dépenses en marketing")
    plt.xticks(rotation=45)
    plt.xlim(0, 600000)
    plt.xlabel('Dépense $')

    plt.subplot(326)
    sns.distplot(data["RDSpend"])
    plt.title("Distribution des dépenses en R&D")
    plt.xticks(rotation=45)
    plt.xlim(0, 300000)
    plt.xlabel('Dépense $')

    plt.savefig("app/static/img/dashboard.png")
    
    return None