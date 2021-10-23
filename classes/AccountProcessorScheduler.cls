global class AccountProcessorScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        AccountProcessorBatch acc = new AccountProcessorBatch('(785) 241-6200');
        Id batchId = Database.executeBatch(acc);
        DateTime t = System.now();
        DateTime newTime = t.addMinutes(5);
        
        String nextscheduleTime = '0 '+ newTime.minuteGMT() + ' * * * ?';
        System.schedule('New job: ' + String.valueOfGMT(newTime),  nextScheduleTime, new AccountProcessorScheduler());
        System.abortJob(ctx.getTriggerId());
    }
}

// To schedule class every 5 minute
// DateTime t = System.now();
// DateTime newTime = t.addMinutes(5);
// String nextScheduleTime = '0 '+ newTime.minuteGMT() + ' * * * ?';
// System.schedule('New job: ' + String.valueOfGMT(newTime),  nextScheduleTime, new AccountProcessorScheduler());
