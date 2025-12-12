ALTER TABLE "courses" ALTER COLUMN "name" SET DATA TYPE varchar;--> statement-breakpoint
ALTER TABLE "courses" ALTER COLUMN "description" SET DATA TYPE varchar;--> statement-breakpoint
ALTER TABLE "courses" ALTER COLUMN "level" SET DATA TYPE varchar;--> statement-breakpoint
ALTER TABLE "courses" ALTER COLUMN "category" SET DATA TYPE varchar;--> statement-breakpoint
ALTER TABLE "courses" ALTER COLUMN "userEmail" SET DATA TYPE varchar;--> statement-breakpoint
ALTER TABLE "courses" ALTER COLUMN "bannerImageURL" SET DATA TYPE varchar;--> statement-breakpoint
ALTER TABLE "courses" ALTER COLUMN "bannerImageURL" SET DEFAULT '';--> statement-breakpoint
ALTER TABLE "courses" ALTER COLUMN "courseContent" SET DATA TYPE varchar;--> statement-breakpoint
ALTER TABLE "enrollments" ALTER COLUMN "userEmail" SET DATA TYPE varchar;