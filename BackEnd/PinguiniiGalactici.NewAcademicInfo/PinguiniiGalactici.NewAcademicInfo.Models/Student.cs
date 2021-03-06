﻿using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PinguiniiGalactici.NewAcademicInfo.Models
{
    [DataContract(Name = "Table1")]
    public class Student
    {
        [DataMember(Name = "RegistrationNumber")]
        public Int32 RegistrationNumber { get; set; }
        [DataMember(Name = "Name")]
        public String Name { get; set; }
        [DataMember(Name = "Email")]
        public string Email { get; set; }
        [DataMember(Name = "GroupNumber")] 
        public Int32 GroupNumber { get; set; }
        [DataMember(Name = "Password")]
        public string Password { get; set; }
    }
}
