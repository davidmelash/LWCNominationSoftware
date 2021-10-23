global class HourlyAccountProcessorBatch implements Schedulable {
    global void execute(SchedulableContext ctx) {
        AccountProcessorBatch acc = new AccountProcessorBatch('(785) 241-6200');
        Id batchId = Database.executeBatch(acc);
    }
}


// To schedule class every hour
// HourlyAccountProcessorBatch newJob = new HourlyAccountProcessorBatch();
// String sch = '0 0 * * * ?';
// String jobID = System.schedule('Hourly', sch, newJob);
