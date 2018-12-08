﻿using Microsoft.IdentityModel.Tokens;
using PinguiniiGalactici.NewAcademicInfo.Models;
using PinguiniiGalactici.NewAcademicInfo.WebAPI.Core;
using PinguiniiGalactici.NewAcademicInfo.WebAPI.Filters;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web;
using System.Web.Http;

namespace PinguiniiGalactici.NewAcademicInfo.WebAPI.Controllers
{

    [RoutePrefix("departments")]
    public class DepartmentController : MainAPIController
    {
        //[Route("{userID:Guid}")] - example for Guid (type must be specified)
        #region Methods
        [AuthenticationFilter]
        [HttpGet]
        [Route("")]
        //[AuthorizationFilter(Role.Administrator)]
        public IEnumerable<Department> ReadAll()
        {
            return BusinessContext.DepartmentBusiness.ReadAll();
        }

        [AuthenticationFilter]
        [HttpGet]
        [Route("{departmentID:Guid}")]
        public Department ReadById(Guid departmentID)
        {
            return BusinessContext.DepartmentBusiness.ReadById(departmentID);
        }

        [AuthenticationFilter]
        [HttpPost]
        [Route("")]
        public void Insert([FromBody]Department department)
        {
            BusinessContext.DepartmentBusiness.Insert(department);
        }

        [AuthenticationFilter]
        [HttpPut]
        [Route("")]
        public void Update([FromBody]Department department)
        {
            BusinessContext.DepartmentBusiness.Update(department);
        }

        [AuthenticationFilter]
        [HttpDelete]
        [Route("{departmentID:Guid}")]
        public void Delete(Guid departmentID)
        {
            BusinessContext.DepartmentBusiness.Delete(departmentID);
        }

        #endregion

        private const string Secret = "ab3OIsj+BXE9NZDy0t8W3TcNekrF+2d/1sFnWG4HnV8TZY30iTOdtVWJG8abWvB1GlOgJuQZdcF2Luqm/hccMw==";
        public static string GenerateToken(string username, int expireMinutes = 20)
        {
            var symmetricKey = Convert.FromBase64String(Secret);
            var tokenHandler = new JwtSecurityTokenHandler();

            var now = DateTime.UtcNow;
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                        {
                        new Claim(ClaimTypes.Name, username)
                    }),

                Expires = now.AddMinutes(Convert.ToInt32(expireMinutes)),

                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(symmetricKey), SecurityAlgorithms.HmacSha256Signature)
            };

            var stoken = tokenHandler.CreateToken(tokenDescriptor);
            var token = tokenHandler.WriteToken(stoken);

            return token;
        }

        private static bool ValidateToken(string token, out string username) // return true and the username if token was correct
        {
            username = null;

            var simplePrinciple = GetPrincipal(token);
            var identity = simplePrinciple.Identity as ClaimsIdentity;

            if (identity == null)
                return false;

            if (!identity.IsAuthenticated)
                return false;

            var usernameClaim = identity.FindFirst(ClaimTypes.Name);
            username = usernameClaim?.Value;

            if (string.IsNullOrEmpty(username))
                return false;

            // More validate to check whether username exists in system

            return true;
        }


        public static ClaimsPrincipal GetPrincipal(string token)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var jwtToken = tokenHandler.ReadToken(token) as JwtSecurityToken;

                if (jwtToken == null)
                    return null;

                var symmetricKey = Convert.FromBase64String(Secret);

                var validationParameters = new TokenValidationParameters()
                {
                    RequireExpirationTime = true,
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    IssuerSigningKey = new SymmetricSecurityKey(symmetricKey)
                };

                SecurityToken securityToken;
                var principal = tokenHandler.ValidateToken(token, validationParameters, out securityToken);

                return principal;
            }

            catch (Exception)
            {
  
                return null;
            }
        }
    }
}


