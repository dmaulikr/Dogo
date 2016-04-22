//
//  DGDatabase.h
//  Dogo
//
//  Created by Marsal on 08/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import <FMDB/FMDB.h>

/*
 * A Facade interface to facilitate the use of FMDB API (database/connection).
 * The main goal is abstract the initialization of database in the first use, creating the database file and his tables.
 */
@interface DGDatabase : FMDatabase

@end