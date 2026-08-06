import { PrismaClient } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Create workers
  const workers = [];
  const workerData = [
    { name: 'Ramesh Kumar', phone: '9876543210', skills: ['Painting', 'Wall Repair'], wage: 800, lat: 28.6139, lng: 77.2090 },
    { name: 'Suresh Yadav', phone: '9876543211', skills: ['Plumbing', 'Pipe Fitting'], wage: 900, lat: 28.6200, lng: 77.2150 },
    { name: 'Amit Singh', phone: '9876543212', skills: ['Electrical', 'Wiring'], wage: 1000, lat: 28.6100, lng: 77.2050 },
    { name: 'Raj Patel', phone: '9876543213', skills: ['Cleaning', 'Deep Cleaning'], wage: 600, lat: 28.6300, lng: 77.2200 },
    { name: 'Vikram Sharma', phone: '9876543214', skills: ['Carpentry', 'Furniture Repair'], wage: 1200, lat: 28.6050, lng: 77.1980 },
    { name: 'Manoj Tiwari', phone: '9876543215', skills: ['Gardening', 'Landscaping'], wage: 700, lat: 28.6250, lng: 77.2100 },
    { name: 'Deepak Verma', phone: '9876543216', skills: ['Cooking', 'Catering'], wage: 850, lat: 28.6180, lng: 77.2120 },
    { name: 'Sanjay Gupta', phone: '9876543217', skills: ['Painting', 'Interior Design'], wage: 1100, lat: 28.6160, lng: 77.2080 },
  ];

  for (const w of workerData) {
    const user = await prisma.user.create({
      data: {
        phone: w.phone,
        name: w.name,
        role: 'WORKER',
        latitude: w.lat,
        longitude: w.lng,
        language: 'hi',
      },
    });
    await prisma.workerProfile.create({
      data: {
        userId: user.id,
        skills: JSON.stringify(w.skills),
        expectedWage: w.wage,
        wageType: 'DAILY',
        isAvailable: true,
        workRadius: 10,
        thumbsUp: Math.floor(Math.random() * 50) + 10,
        thumbsDown: Math.floor(Math.random() * 5),
      },
    });
    workers.push(user);
  }

  // Create households
  const households = [];
  const householdData = [
    { name: 'Priya Mehta', phone: '9988776601', address: '42, Vasant Kunj, New Delhi', lat: 28.5200, lng: 77.1500 },
    { name: 'Anita Sharma', phone: '9988776602', address: '15, Hauz Khas, New Delhi', lat: 28.5494, lng: 77.2001 },
    { name: 'Vikash Gupta', phone: '9988776603', address: '78, Greater Kailash, New Delhi', lat: 28.5500, lng: 77.2400 },
    { name: 'Sunita Jain', phone: '9988776604', address: '33, Dwarka Sector 12, New Delhi', lat: 28.5921, lng: 77.0460 },
    { name: 'Rohit Kapoor', phone: '9988776605', address: '55, Saket, New Delhi', lat: 28.5245, lng: 77.2066 },
  ];

  for (const h of householdData) {
    const user = await prisma.user.create({
      data: {
        phone: h.phone,
        name: h.name,
        role: 'HOUSEHOLD',
        latitude: h.lat,
        longitude: h.lng,
        language: 'en',
      },
    });
    await prisma.householdProfile.create({
      data: {
        userId: user.id,
        address: h.address,
        thumbsUp: Math.floor(Math.random() * 30) + 5,
        thumbsDown: Math.floor(Math.random() * 3),
      },
    });
    households.push(user);
  }

  // Create jobs
  const jobData = [
    { title: 'House Painting - 2BHK', desc: 'Need to paint entire 2BHK apartment. Walls and ceiling. Material will be provided.', category: 'Painting', budget: 5000, type: 'FIXED' as const },
    { title: 'Kitchen Plumbing Repair', desc: 'Kitchen sink is leaking and bathroom tap needs replacement. Please bring your own tools.', category: 'Plumbing', budget: 1500, type: 'NEGOTIABLE' as const },
    { title: 'Full House Deep Cleaning', desc: 'Deep cleaning required for 3BHK apartment. Including bathrooms, kitchen, and balcony.', category: 'Cleaning', budget: 3000, type: 'FIXED' as const },
    { title: 'Electrical Wiring Fix', desc: 'Several switches not working. Need to check wiring in living room and bedroom.', category: 'Electrical', budget: 2000, type: 'NEGOTIABLE' as const },
    { title: 'Garden Maintenance', desc: 'Monthly garden maintenance needed. Lawn mowing, pruning, and watering.', category: 'Gardening', budget: 1200, type: 'FIXED' as const },
    { title: 'Furniture Repair', desc: 'Wooden dining table needs repair. One leg is broken and surface needs polish.', category: 'Carpentry', budget: 2500, type: 'NEGOTIABLE' as const },
    { title: 'Cook for House Party', desc: 'Need an experienced cook for a party of 20 guests. North Indian and Chinese cuisine.', category: 'Cooking', budget: 4000, type: 'FIXED' as const },
    { title: 'Bathroom Tiles Replacement', desc: 'Need to replace broken tiles in bathroom. Approximately 50 sq ft area.', category: 'Painting', budget: 3500, type: 'FIXED' as const },
  ];

  const jobs = [];
  for (let i = 0; i < jobData.length; i++) {
    const h = households[i % households.length];
    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + Math.floor(Math.random() * 14) + 1);

    const job = await prisma.job.create({
      data: {
        householdId: h.id,
        title: jobData[i].title,
        description: jobData[i].desc,
        category: jobData[i].category,
        jobDate: futureDate,
        jobTime: `${9 + Math.floor(Math.random() * 4)}:00 AM`,
        latitude: (h.latitude || 28.6) + (Math.random() - 0.5) * 0.05,
        longitude: (h.longitude || 77.2) + (Math.random() - 0.5) * 0.05,
        address: householdData[i % householdData.length].address,
        budgetAmount: jobData[i].budget,
        budgetType: jobData[i].type,
        status: i < 6 ? 'OPEN' : (i === 6 ? 'ASSIGNED' : 'COMPLETED'),
        assignedWorkerId: i >= 6 ? workers[i % workers.length].id : undefined,
      },
    });
    jobs.push(job);
  }

  // Create interests for open jobs
  for (let i = 0; i < 6; i++) {
    const numInterests = Math.floor(Math.random() * 4) + 1;
    for (let j = 0; j < numInterests; j++) {
      const worker = workers[(i + j) % workers.length];
      try {
        await prisma.jobInterest.create({
          data: {
            jobId: jobs[i].id,
            workerId: worker.id,
            status: 'PENDING',
          },
        });
      } catch { /* skip duplicates */ }
    }
  }

  // Create some ratings for completed jobs
  if (jobs.length > 7) {
    const completedJob = jobs[7];
    const rater = households.find(h => h.id === completedJob.householdId);
    if (rater && completedJob.assignedWorkerId) {
      await prisma.rating.create({
        data: {
          jobId: completedJob.id,
          raterId: rater.id,
          ratedUserId: completedJob.assignedWorkerId,
          value: 'THUMBS_UP',
          comment: 'Great work! Very professional and on time.',
        },
      });
    }
  }

  // Create notifications
  for (const worker of workers.slice(0, 3)) {
    await prisma.notification.create({
      data: {
        userId: worker.id,
        type: 'NEW_JOB',
        title: 'New Job Near You!',
        body: 'A new painting job has been posted near your location.',
        data: JSON.stringify({ jobId: jobs[0].id }),
        isRead: false,
      },
    });
  }

  console.log('✅ Seeding complete!');
  console.log(`   ${workers.length} workers created`);
  console.log(`   ${households.length} households created`);
  console.log(`   ${jobs.length} jobs created`);
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
