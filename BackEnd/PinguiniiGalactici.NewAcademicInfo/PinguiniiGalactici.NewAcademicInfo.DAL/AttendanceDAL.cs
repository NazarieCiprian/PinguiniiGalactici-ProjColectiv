﻿using PinguiniiGalactici.NewAcademicInfo.DAL.Core;
using PinguiniiGalactici.NewAcademicInfo.Library;
using PinguiniiGalactici.NewAcademicInfo.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PinguiniiGalactici.NewAcademicInfo.DAL
{
    public class AttendanceDAL : DALObject
    {
        #region Constructors
        public AttendanceDAL(DALContext context) : base(context) { }
        private static string tableName = "Table4";
        #endregion

        #region Methods
        public IEnumerable<Attendance> ReadAll()
        {
            return DbOperations.ExecuteQuery<Attendance>(_context.CONNECTION_STRING, "dbo." + tableName + "_ReadAll");
        }

        //aka ReadByID for the other models
        public Attendance ReadById(Guid AttendanceID)
        {
            return DbOperations.ExecuteQuery<Attendance>(_context.CONNECTION_STRING, "dbo." + tableName + "_ReadByID", new SqlParameter("AttendanceID", AttendanceID)).FirstOrDefault();
        }

        public void Insert(Attendance attendances)
        {
            DbOperations.ExecuteCommand(_context.CONNECTION_STRING, "dbo." + tableName + "_Insert", attendances.GenerateSqlParametersFromModel().ToArray());
        }

        public void Update(Attendance attendances)
        {
            DbOperations.ExecuteCommand(_context.CONNECTION_STRING, "dbo." + tableName + "_Update", attendances.GenerateSqlParametersFromModel().ToArray());
        }

        public void Delete(Guid AttendanceID)
        {
            DbOperations.ExecuteCommand(_context.CONNECTION_STRING, "dbo." + tableName + "_Delete", new SqlParameter("AttendanceID", AttendanceID));
        }
        #endregion
    }
}