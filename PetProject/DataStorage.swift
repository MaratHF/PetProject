//
//  DataStorage.swift
//  PetProject
//
//  Created by MAC  on 05.07.2022.
//

import Foundation

struct DataStorage {
    let descriptionsOfSleepDuration = ["Отлично!", "Хорошо", "Нормально", "Плохо", "Очень плохо!"]
    
    let sections = [
    Section(
        title: "Ложитесь спать и просыпайтесь в одно и то же время",
        subtitle: "Многие из нас по выходным дают себе поблажки и спят чуть ли не до самого обеда. Однако учёные считают, что из-за такого непостоянства сбиваются наши циркадные ритмы. Улучшить сон поможет ежедневный подъём и отход ко сну в одно и то же время."
           ),
    Section(
        title: "Устраивайте перерывы на сон, если чувствуете усталость",
        subtitle: "Немного вздремнув, вы снова обретёте бодрость. Однако учитывайте, что послеобеденный сон не должен длиться дольше 45 минут."
           ),
    Section(
        title: "Откажитесь от вредных привычек",
        subtitle: "Специалисты советуют не употреблять алкоголь и не курить хотя бы за четыре часа до сна. Хотя эти привычки лучше всего бросить раз и навсегда."
    ),
    Section(
        title: "Сократите употребление кофеина",
        subtitle: "По рекомендациям Всемирного общества сна как минимум за шесть часов до отхода ко сну необходимо перестать употреблять кофеин. Имейте в виду, что он содержится не только в кофе, но также в чае, газированных напитках и даже шоколаде."
    ),
    Section(
        title:  "Не наедайтесь перед сном",
        subtitle: "Можно устроить лёгкий перекус. Но за четыре часа до сна не следует налегать на тяжёлую, острую и сладкую пищу."
    ),
    Section(
        title: "Не занимайтесь спортом перед сном",
        subtitle: "Специалисты настаивают на том, что спортом нужно заниматься регулярно. Однако физическая активность непосредственно перед отходом ко сну может навредить его качеству."
    ),
    Section(
        title: "Выбирайте комфортные постельные принадлежности",
        subtitle: "Если посреди ночи вы просыпаетесь от того, что вам жарко под привычным шерстяным одеялом, значит, пришло время его сменить. Ради своего же здоровья."
    ),
    Section(
        title: "Устраните отвлекающие шумы и свет",
        subtitle: "Находящаяся в комнате электроника может помешать вам выспаться. Например, мигающие цифровые часы, гудящий компьютер и, конечно, включённый телевизор."
    ),
    Section(
        title: "Не занимайтесь на кровати посторонними делами",
        subtitle: "С помощью смартфона или ноутбука мы легко можем отвечать на email, лёжа на кровати. Однако это может привести к тому, что вы будете ассоциировать это место с работой. Перестаньте так делать. Постель предназначена для сна и секса."
    )
    ]
    
    let additionalNotificationsList = [
        "Медитация",
        "Обдумывание того, что произошло за день",
        "Почитать книгу",
        "Проветрить помещение"
    ]
}




let date1 = Date() - 86400
let date2 = Date() - (86400 * 2)
let date3 = Date() - (86400 * 3)
let date4 = Date() - (86400 * 4)
let date5 = Date() - (86400 * 5)
let date6 = Date() - (86400 * 6)
let date7 = Date() - (86400 * 7)
let date8 = Date() - (86400 * 8)
let date9 = Date() - (86400 * 9)
let date10 = Date() - (86400 * 10)
let date11 = Date() - (86400 * 11)
let date12 = Date() - (86400 * 12)
let date13 = Date() - (86400 * 13)
let date14 = Date() - (86400 * 14)
let date15 = Date() - (86400 * 15)
let date16 = Date() - (86400 * 16)
let date17 = Date() - (86400 * 17)
let date18 = Date() - (86400 * 18)
let date19 = Date() - (86400 * 19)
let date20 = Date() - (86400 * 20)
let date21 = Date() - (86400 * 21)
let date22 = Date() - (86400 * 22)
let date23 = Date() - (86400 * 23)
let date24 = Date() - (86400 * 24)
let date25 = Date() - (86400 * 25)
let date26 = Date() - (86400 * 26)
let date27 = Date() - (86400 * 27)
let date28 = Date() - (86400 * 28)
let date29 = Date() - (86400 * 29)
let date30 = Date() - (86400 * 30)
let date31 = Date() - (86400 * 31)

struct SleepData {
    var sleepDays: [SleepDay] = [
    SleepDay(date: Date(), hour: 1, minute: 30),
    SleepDay(date: date1, hour: 8, minute: 2),
    SleepDay(date: date2, hour: 9, minute: 20),
    SleepDay(date: date3, hour: 10, minute: 50),
    SleepDay(date: date4, hour: 5, minute: 40),
    SleepDay(date: date5, hour: 6, minute: 34),
    SleepDay(date: date6, hour: 15, minute: 30),
    SleepDay(date: date7, hour: 9, minute: 15),
    SleepDay(date: date8, hour: 6, minute: 30),
    SleepDay(date: date9, hour: 5, minute: 22),
    SleepDay(date: date10 , hour: 7, minute: 30),
    SleepDay(date: date11, hour: 8, minute: 45),
    SleepDay(date: date12, hour: 9, minute: 50),
    SleepDay(date: date13, hour: 9, minute: 0),
    SleepDay(date: date14, hour: 8, minute: 30),
    SleepDay(date: date15, hour: 5, minute: 55),
    SleepDay(date: date16, hour: 6, minute: 13),
    SleepDay(date: date17, hour: 7, minute: 32),
    SleepDay(date: date18, hour: 2, minute: 2),
    SleepDay(date: date19, hour: 4, minute: 34),
    SleepDay(date: date20, hour: 8, minute: 18),
    SleepDay(date: date21, hour: 1, minute: 11),
    SleepDay(date: date22, hour: 9, minute: 41),
    SleepDay(date: date23, hour: 12, minute: 11),
    SleepDay(date: date24, hour: 15, minute: 0),
    SleepDay(date: date25, hour: 10, minute: 00),
    SleepDay(date: date26, hour: 9, minute: 00),
    SleepDay(date: date27, hour: 8, minute: 00),
    SleepDay(date: date28, hour: 7, minute: 9),
    SleepDay(date: date29, hour: 6, minute: 9),
    SleepDay(date: date30, hour: 8, minute: 30),
    SleepDay(date: date31, hour: 8, minute: 0)
    ]
    
}
